import { Body, Controller, Post, HttpException, HttpStatus, Res } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { CartItemDto } from './dto/cart-item.dto';
import { StripeService } from 'src/stripe/stripe.service';
import { Response } from 'express';

@Controller('payments')
export class PaymentsController {
    constructor(
        private readonly paymentsService: PaymentsService,
        private readonly stripeService: StripeService // Inject the StripeService
    ) { }

    @Post('process-purchase')
    async processPurchase(
        @Body() body: { cartItems: CartItemDto[]; paymentMethodId: string },
        @Res() response: Response
    ) {
        try {
            const { cartItems, paymentMethodId } = body;
            const isValid = await this.paymentsService.validateCartItems(cartItems);

            if (isValid) {
                const totalAmount = this.paymentsService.calculateCartTotal(cartItems);

                const paymentIntent = await this.stripeService.createPaymentIntent(totalAmount, 'usd', paymentMethodId);

                await this.stripeService.confirmPayment(paymentIntent.id, paymentMethodId);

                response.status(HttpStatus.OK).json({ message: 'Payment processed successfully.' });
            } else {
                response.status(HttpStatus.BAD_REQUEST).json({ message: 'Invalid cart items.' });
            }
        } catch (error) {
            response.status(HttpStatus.INTERNAL_SERVER_ERROR).json({ message: error.message });
        }
    }
}
