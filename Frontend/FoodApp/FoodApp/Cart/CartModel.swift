//
//  CartModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import Foundation

struct CartItem: Identifiable, Codable {
    var id: Int { product.id }
    let product: Product
    var quantity: Int
}

