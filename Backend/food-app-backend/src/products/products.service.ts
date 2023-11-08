import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable()
export class ProductsService {
  constructor(private httpService: HttpService) {}

  findAll(): Observable<any[]> {
    return this.httpService.get('https://www.themealdb.com/api/json/v1/1/categories.php')
      .pipe(
        map(response => {
            console.log(response.data);
            return response.data.categories
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

      const basePrice = this.categoryPricing[product.category] || this.generateRandomPrice();
      product.price = basePrice; 
      return product;
    });
  }
  
  private generateRandomPrice(): number {
    return Math.floor(Math.random() * (100 - 10 + 1)) + 10;
  }
}
