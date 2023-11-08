import { Controller, Get, HttpException, HttpStatus } from '@nestjs/common';
import { Observable } from 'rxjs';
import { ProductsService } from './products.service';

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  findAll(): Observable<any[]> {
    return this.productsService.findAll();
  }
}