import { Injectable, Logger, HttpException, HttpStatus, OnModuleInit } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { Observable } from 'rxjs';
import { first, map } from 'rxjs/operators';
import { Product } from './product.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { lastValueFrom } from 'rxjs';



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
    ) { }

    findAll(): Observable<any[]> {
        return this.httpService.get('https://www.themealdb.com/api/json/v1/1/products.php')
            .pipe(
                map(response => {
                    console.log(response.data);
                    return response.data.products
                })
            );
    }

    private categoryPricing = {
        Lamb: 50,
        Beef: 45,
        Pork: 30,
    };

    private assignPricesToProducts(products: any[]): any[] {
        return products.map(product => {

            const basePrice = this.categoryPricing[product.product] || this.generateRandomPrice();
            product.price = basePrice;
            return product;
        });
    }

    private generateRandomPrice(): number {
        return Math.floor(Math.random() * (100 - 10 + 1)) + 10;
    }

    // Fetch products from the API and save them to the database
    async fetchAndSaveProducts(url: string): Promise<Product[]> {
        const productsData = await this.fetchProductsFromAPI(url);
        const transformedProducts = this.transformAndValidateProducts(productsData);
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
    private transformAndValidateProducts(apiProducts: APIProduct[]): Product[] {
        const validPoducts: Product[] = [];

        for (const apiProduct of apiProducts) {
            const isValidProduct = typeof apiProduct.idMeal === 'string' &&
                typeof apiProduct.strMeal === 'string' &&
                typeof apiProduct.strMealThumb === 'string'


            if (isValidProduct) {
                const product = new Product();
                product.productName = apiProduct.strMeal.trim();
                product.productThumbnail = apiProduct.strMealThumb.trim();
                product.price = 0


                validPoducts.push(product)
            } else {
                this.logger.warn(`Invalid product data encountered: ${JSON.stringify(apiProduct)}`);
            }
        }

        return validPoducts;
    }

    // Save products to the database
    private async saveProductsToDB(productsData: Product[]): Promise<Product[]> {
        const results = await Promise.allSettled(productsData.map(productData =>
            this.productRepository.save(productData)
        ));

        const savedProducts: Product[] = [];

        results.forEach((result, index) => {
            if (result.status === 'fulfilled') {
                savedProducts.push(result.value);
            } else { // if 'rejected'
                this.logger.error(`Failed to save product: ${productsData[index].productName}`, result.reason);
            }
        });

        return savedProducts;
    }

}
