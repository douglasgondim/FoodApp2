import { IsInt, IsNumber, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class ProductDto {
    @IsInt()
    productId: number;

    @IsString()
    productName: string;

    @IsString()
    productThumbnail: string;

    @IsNumber()
    productPrice: number;
}

export class CartItemDto {
    @ValidateNested()
    @Type(() => ProductDto)
    product: ProductDto;

    @IsInt()
    quantity: number;
}
