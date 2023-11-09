import { Injectable, Logger, HttpException, HttpStatus, OnModuleInit } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Category } from './category.entity';
import { map } from 'rxjs/operators';
import { lastValueFrom } from 'rxjs';
import { first } from 'rxjs/operators';

// Interface for object that's expected from TheMealDB API
interface APICategory {
    idCategory: string;
    strCategory: string;
    strCategoryThumb: string;
    strCategoryDescription: string;
}

@Injectable()
export class CategoriesService {
    private readonly logger = new Logger(CategoriesService.name);

    constructor(
        private httpService: HttpService,
        @InjectRepository(Category)
        private categoryRepository: Repository<Category>,


    ) { }

    // Get all available categories
    async getAllCategories(): Promise<Category[]> {
        return await this.categoryRepository.find();
    }


    // Fetch categories from TheMealDB API and save them to the database
    async fetchAndSaveCategories(): Promise<Category[]> {
        const url = "https://www.themealdb.com/api/json/v1/1/categories.php"
        const apiCategoriesData = await this.fetchCategoriesFromAPI(url);
        const transformedCategories = this.transformAndValidateCategories(apiCategoriesData);
        const savedCategories = await this.saveCategoriesToDB(transformedCategories);
        return savedCategories;
    }

    private async fetchCategoriesFromAPI(url: string): Promise<APICategory[]> {
        try {
            const response$ = this.httpService.get<{ categories: APICategory[] }>(url).pipe(
                map(response => response.data.categories),
                first() // Take the first emitted value and complete the observable
            );
            return await lastValueFrom(response$);
        } catch (error) {
            const errorMessage = `Failed to fetch categories from API: ${error.message}`;
            this.logger.error(errorMessage, error.stack);
            throw new HttpException(errorMessage, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Validate data types received from the API and return an array of Category
    private transformAndValidateCategories(apiCategories: APICategory[]): Category[] {
        const validCategories: Category[] = [];

        for (const apiCategory of apiCategories) {
            const isValidCategory = typeof apiCategory.idCategory === 'string' &&
                typeof apiCategory.strCategory === 'string' &&
                typeof apiCategory.strCategoryThumb === 'string' &&
                typeof apiCategory.strCategoryDescription === 'string';


            if (isValidCategory) {
                const category = new Category();
                category.categoryName = apiCategory.strCategory.trim();
                category.categoryThumbnail = apiCategory.strCategoryThumb.trim();
                category.categoryDescription = apiCategory.strCategoryDescription.trim();

                validCategories.push(category)
            } else {
                this.logger.warn(`Invalid category data encountered: ${JSON.stringify(apiCategory)}`);
            }
        }

        return validCategories;
    }

    // Save array of Categories to the database
    private async saveCategoriesToDB(categoriesData: Category[]): Promise<Category[]> {
        const results = await Promise.allSettled(categoriesData.map(categoryData =>
            this.categoryRepository.save(categoryData)
        ));

        const savedCategories: Category[] = [];

        results.forEach((result, index) => {
            if (result.status === 'fulfilled') {
                savedCategories.push(result.value);
            } else { // if 'rejected'
                this.logger.error(`Failed to save category: ${categoriesData[index].categoryName}`, result.reason);
            }
        });

        return savedCategories;
    }

    // Check if the database is populated
    async isCategoriesPopulated(): Promise<boolean> {
        const count = await this.categoryRepository.count();
        return count > 0;
    }

}