import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import Stripe from 'stripe';

@Injectable()
export class StripeService {
  private stripe: Stripe;

  constructor() {
    this.stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
      apiVersion: '2023-10-16',
    });
  }

  // Create payment intent
  async createPaymentIntent(amount: number, currency: string, paymentId: string): Promise<Stripe.PaymentIntent> {
    // Send the amount in cents by multiplying by 100
    return this.stripe.paymentIntents.create({
      amount: amount * 100,
      currency,
      payment_method: paymentId,
      automatic_payment_methods: { enabled: true, allow_redirects: 'never' },
    });
  }

  // Confirm payment intent
  async confirmPayment(paymentIntentId: string, paymentMethodId: string): Promise<Stripe.PaymentIntent> {
    try {
      return await this.stripe.paymentIntents.confirm(paymentIntentId, {
        payment_method: paymentMethodId,
      });
    } catch (error) {
      throw new HttpException('Failed to confirm payment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

}
