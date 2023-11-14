//
//  ProductModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//
//  Description: This file defines the data models related to products, including the structure for product responses
//  and individual product details. It ensures these models are compliant with Codable for easy JSON encoding and decoding.

import Foundation

// Codable struct for handling product list responses from the API.
struct ProductsResponse: Codable {
    let products: [Product]  // Array of products in the response.
}

// Struct representing an individual product, conforming to Codable for JSON parsing.
struct Product: GeneralItemProtocol, Codable {
    let productId: Int       
    let productName: String
    let productThumbnail: String
    let productPrice: Double

    // Computed properties conforming to the GeneralItemProtocol.
    var thumbnail: String { productThumbnail }
    var title: String { productName }
    var id: Int { productId }

    // CodingKeys enum for defining custom keys for Codable protocol.
    enum CodingKeys: String, CodingKey {
        case productId
        case productName
        case productThumbnail
        case productPrice
    }
}
