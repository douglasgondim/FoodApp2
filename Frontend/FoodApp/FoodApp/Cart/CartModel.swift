//
//  CartModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//
//  Description: This file defines the CartItem model used in the application to represent an item in the user's shopping cart.


import Foundation

struct CartItem: Identifiable, Codable {
    var id: Int { product.id }
    let product: Product
    var quantity: Int
}

