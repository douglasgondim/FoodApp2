//
//  ProductListViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import Foundation
import Combine
class ProductsListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var showConfirmation: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    private let apiService : APIService
    private let cartViewModel : CartViewModel
    private var category : Category
    
    init(apiService : APIService, cartViewModel : CartViewModel, category : Category) {
        self.category = category
        self.apiService = apiService
        self.cartViewModel = cartViewModel
        loadProducts(for: category.categoryName)
    }
    
    func getCategoryName() -> String{
        return category.categoryName
    }
    func addProductToCart(_ product: Product) {
        cartViewModel.addToCart(cartItem: CartItem(product: product, quantity: 1))
        showConfirmation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showConfirmation = false
        }
    }
    
    func loadProducts(for category: String) {
        apiService.fetchProductsForCategory(for: category)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }
}
