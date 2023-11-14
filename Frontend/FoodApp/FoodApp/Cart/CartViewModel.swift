//
//  CartViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//
//  Description: This file contains the CartViewModel class which is responsible for managing
//  the cart functionalities including adding, removing items, and handling the payment process.

import Foundation
import SwiftUI

// ViewModel for the cart view.
class CartViewModel: ObservableObject {
    // Property to track cart items.
    @Published var cartItems: [CartItem] = [] {
        didSet {
            saveItems() // Save items to persistent storage when cart items change.
        }
    }
    // Store cart items in UserDefaults for persistence.
    @AppStorage("cartItems") var itemsData: Data = Data()
    // Published property to manage navigation state for payment view.
    @Published var isNavigationActive: Bool = false
    // Track if cart has been paid for.
    var cartHasBeenPaidFor = false
    
    // APIService instance for network requests.
    private var apiService : APIService
    
    // Constructor initializing with APIService.
    init(apiService: APIService) {
        self.apiService = apiService
        loadItems() // Load cart items from persistent storage on initialization.
    }
    
    // Trigger navigation to the payment view.
    func showPaymentView(){
        isNavigationActive = true
    }
    
    // Hide the payment view.
    func hidePaymentView(){
        isNavigationActive = false
    }
       
    // Save cart items to persistent storage.
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(cartItems) {
            itemsData = encodedData
        }
    }
    
    // Load cart items from persistent storage.
    private func loadItems() {
        if let decodedItems = try? JSONDecoder().decode([CartItem].self, from: itemsData) {
            cartItems = decodedItems
        } else {
            // Fallback initialization if no saved data exists.
        }
    }
    
    // Calculate total price of items in the cart.
    var total: Double {
        cartItems.reduce(0) { $0 + $1.product.productPrice * Double($1.quantity) }
    }
    
    // Delete a specific item from the cart.
    func deleteItem(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }
    
    // Calculate the total number of items in the cart.
    var totalItemCount: Int {
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    // Increase quantity of a specific item in the cart.
    func increaseQuantity(of item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity += 1
        }
    }
    
    // Decrease quantity of a specific item in the cart.
    func decreaseQuantity(of item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }), cartItems[index].quantity > 1 {
            cartItems[index].quantity -= 1
        }
    }
    
    // Check if the cart is empty.
    func isCartEmpty() -> Bool {
        return cartItems.count == 0
    }
    
    // Add an item to the cart.
    func addToCart(cartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.product.productId == cartItem.product.productId }) {
            cartItems[index].quantity += cartItem.quantity
        } else {
            cartItems.append(cartItem)
        }
    }
    
    // Reset the cart after payment is processed.
    func resetCart(){
        cartHasBeenPaidFor = false
        cartItems.removeAll()
    }
}
