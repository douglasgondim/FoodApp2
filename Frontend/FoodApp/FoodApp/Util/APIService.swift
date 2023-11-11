//
//  APIService.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import Foundation
import Combine

class APIService {
    func fetchProductsForCategory(for category: String) -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: "http://192.168.18.22:3000/categories/\(category)/products") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ProductsResponse.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                error
            }
            .map { $0.products }
            .eraseToAnyPublisher()
    }
    
    func fetchCategories() -> AnyPublisher<[Category], Error> {
        guard let url = URL(string: "http://192.168.18.22:3000/categories") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                error
            }
            .map { $0.categories }
            .eraseToAnyPublisher()
    }
    
    
    
}

