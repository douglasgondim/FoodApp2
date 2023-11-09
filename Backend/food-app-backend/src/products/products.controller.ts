import { Controller, Get, HttpException, HttpStatus, Param } from '@nestjs/common';
import { Observable } from 'rxjs';
import { ProductsService } from './products.service';

@Controller('products')
export class ProductsController {
    constructor(private readonly productsService: ProductsService) { }


}