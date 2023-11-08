import { Injectable, Logger, HttpException, HttpStatus } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Category } from './category.entity';
import { map } from 'rxjs/operators';
import { lastValueFrom } from 'rxjs';

@Injectable()
export class CategoriesService {
    private readonly logger = new Logger(CategoriesService.name);

    constructor(
        private httpService: HttpService,
        @InjectRepository(Category)
        private categoryRepository: Repository<Category>,
    ) { }

    // Fetch categories from the API and save them to the database
    async fetchAndSaveCategories(): Promise<Category[]> {
        const categoriesData = await this.fetchCategoriesFromAPI();
        const transformedCategories = this.transformAndValidateCategories(categoriesData);
        return this.saveCategoriesToDB(transformedCategories);
    }

    // Fetch categories from TheMealDB API
    async fetchCategoriesFromAPI(): Promise<Category[]> {
        try {
            const response$ = this.httpService.get('https://www.themealdb.com/api/json/v1/1/categories.php').pipe(
                map(response => response.data.categories)
            );
            return await lastValueFrom(response$);
        } catch (error) {
            this.logger.error('Failed to fetch categories from API', error);
            throw new HttpException('Failed to fetch categories from API', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Transform and validate the categories fetched from the API
    private transformAndValidateCategories(apiCategories: any[]): Category[] {
        return apiCategories.map(apiCategory => {
            const category = new Category();
            category.categoryName = apiCategory.strCategory;
            category.categoryThumbnail = apiCategory.strCategoryThumb;
            category.categoryDescription = apiCategory.strCategoryDescription;
            return category;
        });
    }

    // Save categories to the database
    async saveCategoriesToDB(categoriesData: Category[]): Promise<Category[]> {
        try {
            const savePromises = categoriesData.map(async (categoryData) => {
                const existingCategory = await this.categoryRepository.findOne({
                    where: { categoryName: categoryData.categoryName },
                });

                // If the category does not already exist, insert ir to the database.
                if (!existingCategory) {
                    return this.categoryRepository.save(categoryData);
                }
            });
            return Promise.all(savePromises);
        } catch (error) {
            this.logger.error('Failed to save categories to the database', error);
            if (error.code === '23505') { // PostgreSQL unique violation error code
                throw new HttpException('Duplicate category name', HttpStatus.BAD_REQUEST);
            } else {
                throw new HttpException('Failed to save categories to the database', HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }



}