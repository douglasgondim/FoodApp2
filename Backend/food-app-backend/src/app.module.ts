import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProductsModule } from './products/products.module';
import { CategoriesModule } from './categories/categories.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DatabaseInitializerService } from './databaseInitializer.service';

@Module({
  imports: [ProductsModule, CategoriesModule,
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'oneseven',
      password: '654321',
      database: 'food_db',
      autoLoadEntities: true,
      synchronize: true, // Change in production
    })
  ],
  controllers: [AppController],
  providers: [AppService, DatabaseInitializerService],
})
export class AppModule {}
