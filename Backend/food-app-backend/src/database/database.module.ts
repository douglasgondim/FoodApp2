import { Module } from '@nestjs/common';
import { DatabaseService } from './database.service';
import { DatabaseController } from './database.controller';
import { ProductsModule } from 'src/products/products.module';
import { CategoriesModule } from 'src/categories/categories.module';

@Module({
  imports: [
    ProductsModule, CategoriesModule
  ],
  controllers: [DatabaseController],
  providers: [DatabaseService],
  exports: [DatabaseService]
})
export class DatabaseModule {}
