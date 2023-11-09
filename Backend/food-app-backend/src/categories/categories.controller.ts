import { Controller, Get, Param } from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { Category } from './category.entity';
import { ProductsService } from '../products/products.service';
import { Product } from 'src/products/product.entity';

@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService,
    private readonly productsService: ProductsService
  ) { }

  @Get()
  async getAllCategories(): Promise<{ categories: Category[] }> {
    const categories = await this.categoriesService.getAllCategories();
    return { categories }; 
  }

  @Get(':categoryName/products')
  async getProductsByCategory(@Param('categoryName') categoryName: string): Promise<{ products: Product[] }> {
    const products = await this.productsService.getProductsByCategory(categoryName);
    return { products }
  }


}
