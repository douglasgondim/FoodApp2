import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { CategoriesService } from './categories/categories.service';
import { ProductsService } from './products/products.service';

@Injectable()
export class DatabaseInitializerService implements OnModuleInit {
  private readonly logger = new Logger(CategoriesService.name);

  constructor(
    private readonly categoriesService: CategoriesService,
    private readonly productsService: ProductsService,
  ) { }

  // Only execute the first time the server is loaded and if the database is ot yet populated
  async onModuleInit(): Promise<void> {
    const isDatabaseInitialized = await this.categoriesService.isCategoriesPopulated()

    if (!isDatabaseInitialized) {

      await this.initializeDatabase();
    }
  }

  // Fetch all data from TheMealDB API
  private async initializeDatabase(): Promise<void> {
    this.logger.log("Initializing Database.");
    const categories = await this.categoriesService.fetchAndSaveCategories();

    for (const category of categories) {
      try {
        await this.productsService.fetchAndSaveProductsByCategory(category);

      } catch (error) {
        // Handle any errors that occur during fetching/saving products
        this.logger.error(`Failed to fetch or save products for category ${category.categoryName}: ${error.message}`);
      }
    }

    this.logger.log("Database initialization complete.");
  }

}
