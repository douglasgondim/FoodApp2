//
//  CartViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import Foundation
import SwiftUI

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @AppStorage("cartItems") var itemsData: Data = Data()
    private var apiService : APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
        loadItems()
    }
    
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(cartItems) {
            itemsData = encodedData
        }
    }
    
    private func loadItems() {
        if let decodedItems = try? JSONDecoder().decode([CartItem].self, from: itemsData) {
            cartItems = decodedItems
        } else {
            print("failed to laod items in cart.")
            // Fallback initialization if no saved data exists
        }
    }
    
    var total: Double {
        cartItems.reduce(0) { $0 + $1.product.productPrice * Double($1.quantity) }
    }
    
    func deleteItem(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }
    
    func increaseQuantity(of item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity += 1
        }
    }
    
    func decreaseQuantity(of item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }), cartItems[index].quantity > 1 {
            cartItems[index].quantity -= 1
        }
    }
    
    func isCartEmpty() -> Bool {
        return cartItems.count == 0
    }
    
    func addToCart(cartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.product.productId == cartItem.product.productId }) {
            cartItems[index].quantity += cartItem.quantity
        } else {
            cartItems.append(cartItem)
        }
        saveItems()
    }
}
