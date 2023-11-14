import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CartItemDto } from './dto/cart-item.dto';
import { Product } from 'src/products/product.entity';


@Injectable()
export class PaymentsService {

    constructor(
        @InjectRepository(Product)
        private productRepository: Repository<Product>,
    ) {}

    // Validates every item in the cart to check if every property, especially the price, correspond to what
    // the user sent from their device.
    async validateCartItems(cartItems: CartItemDto[]): Promise<boolean> {
        let totalFromDB = 0;

        for (const cartItem of cartItems) {
            const product = await this.productRepository.findOne({ where: { productId: cartItem.product.productId } });

            if (!product) {
                throw new Error('Product not found');
            }

            if (product.productName !== cartItem.product.productName ||
                product.productThumbnail !== cartItem.product.productThumbnail ||
                product.productPrice.toString() !== cartItem.product.productPrice.toString()) {
                throw new Error('Product information does not match');
            }

            totalFromDB += Number(product.productPrice) * cartItem.quantity;
        }

        const totalFromCart = this.calculateCartTotal(cartItems)

        if (totalFromDB !== totalFromCart) {
            throw new Error('Total price mismatch');
        }

        if (totalFromCart == 0) {
            throw new Error('Cart cannot have empty value.');
        }

        return true;
    }

    // Calculate the total value of the cart
    calculateCartTotal(cartItems: CartItemDto[]): number {
        return cartItems.reduce((total, item) => total + item.product.productPrice * item.quantity, 0);
    }


    

}