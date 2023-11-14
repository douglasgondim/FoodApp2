//
//  ProductListViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//
//  Description: This file contains the ProductsListViewModel class responsible for fetching
//  and displaying products based on a selected category. It also manages adding products to the cart.

import Foundation
import Combine

// ViewModel for the products list view.
class ProductsListViewModel: ObservableObject {
    // Published properties to track products and UI states.
    @Published var products: [Product] = []
    @Published var showConfirmation: Bool = false
    @Published var errorMessage: String?
    
    // Set for storing Combine cancellables.
    private var cancellables: Set<AnyCancellable> = []
    // ApiService instance for network communication.
    private let apiService: APIService
    // CartViewModel instance for managing cart-related operations.
    private let cartViewModel: CartViewModel
    // Current category for which products are being fetched.
    private var category: Category
    
    // Initializer for the ViewModel.
    init(apiService: APIService, cartViewModel: CartViewModel, category: Category) {
        self.category = category
        self.apiService = apiService
        self.cartViewModel = cartViewModel
        loadProducts(for: category.categoryName)
    }
    
    // Retrieve category name.
    func getCategoryName() -> String {
        return category.categoryName
    }

    // Function to add a product to the cart.
    func addProductToCart(_ product: Product) {
        cartViewModel.addToCart(cartItem: CartItem(product: product, quantity: 1))
        showConfirmation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showConfirmation = false
        }
    }
    
    // Load products for a specific category from the API.
    func loadProducts(for category: String) {
        products.removeAll()
        apiService.fetchProductsForCategory(for: category)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }
}
