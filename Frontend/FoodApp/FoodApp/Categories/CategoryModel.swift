//
//  CategoryModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories: [Category]
}

struct Category: GeneralItemProtocol, Codable, Hashable {
    let categoryId: Int
    let categoryName: String
    let categoryThumbnail: String
    let categoryDescription : String
    
    var thumbnail: String { categoryThumbnail }
    var title: String { categoryName }
    var id: Int { categoryId }
    
    enum CodingKeys: String, CodingKey {
        case categoryId
        case categoryName
        case categoryThumbnail
        case categoryDescription
    }
    
    
}


