import { HttpModule } from '@nestjs/axios';
import { Module } from '@nestjs/common';
import { ProductsService } from './products.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Product } from './product.entity';
import { Category } from 'src/categories/category.entity';


@Module({
  imports: [HttpModule, TypeOrmModule.forFeature([Product, Category])],
  providers: [ProductsService],
  exports: [ProductsService]
})
export class ProductsModule {}
