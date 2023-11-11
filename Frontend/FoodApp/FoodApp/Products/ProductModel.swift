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

struct Product: GeneralItemProtocol, Codable {
    let productId: Int
    let productName: String
    let productThumbnail: String
    let productPrice: Double
    
    var thumbnail: String { productThumbnail }
    var title: String { productName }
    var id : Int { productId }
    
    
    enum CodingKeys: String, CodingKey {
        case productId
        case productName
        case productThumbnail
        case productPrice
    }
    
    
    
    
}
