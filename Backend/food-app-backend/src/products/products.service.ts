import { Injectable, Logger, HttpException, HttpStatus, InternalServerErrorException } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { first, map } from 'rxjs/operators';
import { Category } from '../categories/category.entity';
import { Product } from './product.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { lastValueFrom } from 'rxjs';


// Interface for object that's expected from TheMealDB API
interface APIProduct {
    idMeal: string;
    strMeal: string;
    strMealThumb: string;
}

@Injectable()
export class ProductsService {
    private readonly logger = new Logger(ProductsService.name);
    constructor(
        private httpService: HttpService,
        @InjectRepository(Product)
        private productRepository: Repository<Product>,
        @InjectRepository(Category)
        private categoryRepository: Repository<Category>
    ) { }

    // Get products by category
    async getProductsByCategory(categoryName: string): Promise<Product[]> {
        try {
            const category = await this.categoryRepository.findOne({
                where: { categoryName },
            });
    
            if (!category) {
                throw new HttpException(`Category with the name '${categoryName}' does not exist.`, HttpStatus.NOT_FOUND);
            }
    
            return await this.productRepository.find({
                where: { category },
            });
        } catch (error) {
            if (error instanceof HttpException) {
                throw error;
            }
    
            // Log the error and throw a more generic internal server error
            this.logger.error(`Failed to get products for category '${categoryName}': ${error.message}`, error.stack);
            throw new HttpException('Failed to get products for the specified category.', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    private assignPriceToProduct(category: string): number {
        const priceRanges = {
            Pork: { min: 20, max: 30 },
            Beef: { min: 31, max: 60 },
            Lamb: { min: 61, max: 100 }
        };

        // Determine the price range for the category or default to a generic range if not found
        const categoryPriceRange = priceRanges[category] || { min: 10, max: 100 };

        // Generate a random price within the selected range
        const price = this.generateRandomPrice(categoryPriceRange.min, categoryPriceRange.max);

        return price;
    }

    private generateRandomPrice(base: number, limit: number): number {
        return Math.floor(Math.random() * (limit - base + 1)) + base;
    }

    // Fetch products from the API and save them to the database
    async fetchAndSaveProductsByCategory(category: Category): Promise<Product[]> {
        const categoryUrl = `https://www.themealdb.com/api/json/v1/1/filter.php?c=${encodeURIComponent(category.categoryName)}`;

        const productsData = await this.fetchProductsFromAPI(categoryUrl);
        const transformedProducts = await this.transformAndValidateProducts(productsData, category);
        return this.saveProductsToDB(transformedProducts);
    }

    // Fetch products from TheMealDB API
    async fetchProductsFromAPI(url: string): Promise<APIProduct[]> {
        try {
            const response$ = this.httpService.get<{ meals: APIProduct[] }>(url).pipe(
                map(response => response.data.meals),
                first()
            );
            return await lastValueFrom(response$);
        } catch (error) {
            const errorMessage = `Failed to fetch products from API: ${error.message}`;
            this.logger.error(errorMessage, error.stack);
            throw new HttpException(errorMessage, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Transform and validate the products fetched from the API
    private async transformAndValidateProducts(apiProducts: APIProduct[], category: Category): Promise<Product[]> {
        const validProducts: Product[] = [];

        for (const apiProduct of apiProducts) {
            const isValidProduct = typeof apiProduct.idMeal === 'string' &&
                typeof apiProduct.strMeal === 'string' &&
                typeof apiProduct.strMealThumb === 'string';

            if (isValidProduct) {
                const product = new Product();
                product.productName = apiProduct.strMeal.trim();
                product.productThumbnail = apiProduct.strMealThumb.trim();
                product.productPrice = this.assignPriceToProduct(category.categoryName);
                product.category= category;

                validProducts.push(product);
            } else {
                this.logger.warn(`Invalid product data encountered: ${JSON.stringify(apiProduct)}`);
            }
        }

        return validProducts;
    }

    // Save products to the database
    private async saveProductsToDB(productsData: Product[]): Promise<Product[]> {
        const results = await Promise.allSettled(productsData.map(productData =>
            this.productRepository.save(productData)
        ));

        const savedProducts: Product[] = [];

        // Log errors for each promise that was rejected
        results.forEach((result, index) => {
            if (result.status === 'fulfilled') {
                savedProducts.push(result.value);
            } else { // if 'rejected'
                this.logger.error(`Failed to save product: ${productsData[index].productName}`, result.reason);
            }
        });

        return savedProducts;
    }

    async deleteAllProducts(): Promise<void> {
        try {
          // Delete all products
          await this.productRepository.createQueryBuilder()
            .delete()
            .from(Product)
            .execute();
        } catch (error) {
          this.logger.error('Failed to delete products', error.stack);
          throw new InternalServerErrorException('Failed to delete products');
        }
      }

}
