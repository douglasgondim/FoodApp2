//
//  CartViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import Foundation
import Combine
import SwiftUI

//class CartViewModel: ObservableObject {
//    var cartItems: [Product] = []
//    private var cancellables = Set<AnyCancellable>()
//
//    init(productsListViewModel: ProductsListViewModel) {
//        productsListViewModel.addProductToCartPublisher
//            .sink { [weak self] product in
//                self?.addProductToCart(product)
//            }
//            .store(in: &cancellables)
//    }
//
//    private func addProductToCart(_ product: Product) {
//        // Logic to add product to the cart
//        cartItems.append(product)
//    }
//
//    // Rest of your ViewModel code
//}

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @AppStorage("cartItems") var itemsData: Data = Data()
    
    init() {
        let apple = Product(productId: 1, productName: "Apple", productThumbnail: "apple.jpg", productPrice: 0.99)
        let banana = Product(productId: 2, productName: "Banana With a touch of papaya a pargeniana", productThumbnail: "banana.jpg", productPrice: 120.59)
        
        items = [
            CartItem(product: apple, quantity: 1),
            CartItem(product: banana, quantity: 220),
            
        ]
        loadItems()
    }
    
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            itemsData = encodedData
        }
    }
    
    private func loadItems() {
        if let decodedItems = try? JSONDecoder().decode([CartItem].self, from: itemsData) {
            items = decodedItems
        } else {
            // Fallback initialization if no saved data exists
        }
    }
    
    var total: Double {
        items.reduce(0) { $0 + $1.product.productPrice * Double($1.quantity) }
    }
    
    func deleteItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func increaseQuantity(of item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += 1
        }
    }
    
    func decreaseQuantity(of item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }), items[index].quantity > 1 {
            items[index].quantity -= 1
        }
    }
    
    func isCartEmpty() -> Bool {
        return items.count == 0
    }
}
