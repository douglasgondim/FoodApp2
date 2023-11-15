# FoodApp (iOS and Backend)

FoodApp is a modern, SwiftUI-based iOS application paired with a robust NestJS backend, offering a seamless food ordering experience. This project showcases cutting-edge features and best practices in full-stack development.

## Setup

### Frontend (iOS)
To get started with the iOS part of FoodApp:
1. Clone the repository.
2. Ensure you have the latest Xcode installed.
3. Obtain a Stripe API key for testing purposes, as the project doesn't include one.
4. Add your Stripe API test key to the FoodApp swift file in `Frontend > FoodApp > FoodApp.swift`.
5. Run the project in Xcode.

### Backend (NestJS)
For setting up the backend:
1. Ensure Docker is installed on your system.
2. Create a `.env` file in the root of the NestJS application with the following variables:

```
    STRIPE_SECRET_KEY=YOUR_STRIPE_TEST_API_KEY
    DB_HOST=db
    DB_PORT=5432
    DB_USERNAME=douglas
    DB_PASSWORD=654321
    DB_NAME=food_db
 ```

3. Run `docker-compose up` in the root directory of the NestJS application.

## Key Features

### Frontend
1. **SwiftUI Framework**: Utilizes SwiftUI for fast, clean, and modern UI development.
2. **Reactive Interface**: Features a reactive interface with dynamic UI elements.
3. **MVVM Architecture**: Adheres to the Model-View-ViewModel (MVVM) pattern.
4. **Flexible Payment System**: Thoughtfully organized payment system with scalable protocols.
5. **Formatted Input Fields**: Masks on credit card fields for enhanced user experience.
6. **Reusable Components**: `GeneralCard` component for displaying products and categories.
7. **Pull to Refresh**: Modern UX feature for updating lists with the latest server data.
8. **Beautiful Interface with Dark Mode Support**: Aesthetically pleasing UI that adapts to light and dark modes.
9. **Centralized API Service**: Manages network connections efficiently.
10. **Persistence with UserDefaults**: Implements data persistence for cart items.
11. **Interactive Cart with Tab Badge**: Shows the current number of items in the cart.
12. **Simple Unit Testing**: Basic unit tests to validate functionality.

### Backend
1. **Custom Database Design**: Own database schema to store products and categories, showcasing advanced database design skills.
2. **TypeORM Over Raw SQL**: Demonstrates organized and efficient database interactions using TypeORM.
3. **Docker Integration**: Emphasizes knowledge of containerization and simplifies deployment and environment setup.
4. **DTOs for Requests**: Employing Data Transfer Objects for structured and maintainable request handling.
5. **Validation Before Payment Processing**: Ensures integrity and security in transaction processing.
6. **Database Restart Option**: Enables refreshing the database with updated items from TheMealAPI, showing adaptability and dynamic data handling.
7. **Security with .csv File**: Utilizes .csv files for secure and manageable configuration.

## Backend Endpoints

### Categories
- **GET All Categories**: `/categories` - Retrieves all categories.
- **GET Products by Category**: `/categories/:categoryName/products` - Fetches products based on the specified category name.

### Database Management
- **POST Restart Database**: `/database/restart` - Restarts the entire database, refreshing all data.
- **DELETE Clear Database**: `/database/clear` - Clears all data from the database.

### Payments
- **POST Process Purchase**: 
  - Endpoint: `/payments/process-purchase`
  - Request Body Structure:
    ```json
    {
      "cartItems": [
        {
          "product": {
            "productId": int,
            "productName": string,
            "productThumbnail": string,
            "productPrice": number
          },
    
          "quantity": int
        }
      ],
      "paymentMethodId": "string"
    }
    ```
  - Description: Handles the processing of a purchase, including cart validation and payment processing through Stripe.

## GIF

<img src="https://github.com/douglasgondim/FoodApp/blob/main/Screenshots/light-mode.gif" width="300"  alt="FoodApp Light Mode">

## Conclusion
This full-stack project demonstrates a comprehensive skill set in modern iOS and backend development, focusing on a clean, user-friendly interface and a secure, efficient backend.
