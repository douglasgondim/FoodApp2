// payments.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentsService } from './payments.service';
import { PaymentsController } from './payments.controller';
import { Product } from 'src/products/product.entity';
import { ProductsModule } from 'src/products/products.module';
import { StripeModule } from 'src/stripe/stripe.module';

@Module({
  imports: [TypeOrmModule.forFeature([Product]), ProductsModule, StripeModule],
  controllers: [PaymentsController],
  providers: [PaymentsService],
})
export class PaymentsModule {}
