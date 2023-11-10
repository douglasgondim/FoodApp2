//
//  ProductModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [Product]
}

struct Product: Identifiable, Codable {
    let id: Int
    let productName: String
    let productThumbnail: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case productName
        case productThumbnail
        case price
    }
}
