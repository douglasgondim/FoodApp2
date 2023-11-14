import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProductsModule } from './products/products.module';
import { CategoriesModule } from './categories/categories.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StripeModule } from './stripe/stripe.module';
import { PaymentsModule } from './payments/payments.module';
import { DatabaseService } from './database/database.service';
import { DatabaseController } from './database/database.controller';
import { DatabaseModule } from './database/database.module';

@Module({
  imports: [ProductsModule, CategoriesModule,
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT, 10),
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      autoLoadEntities: true,
      synchronize: true, // Change in production
    }),
    StripeModule,
    PaymentsModule,
    DatabaseModule
  ],
  controllers: [AppController, DatabaseController],
  providers: [AppService, DatabaseService],
})
export class AppModule {}
