//
//  APIService.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
    case serverError(String)
    case dataProcessingError
    case badServerResponse
}

class APIService {
    let localHost = "192.168.18.22"
    
    func fetchProductsForCategory(for category: String) -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: "http://\(localHost):3000/categories/\(category)/products") else {
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
        guard let url = URL(string: "http://\(localHost):3000/categories") else {
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
    

    func processPurchase(_ cartItems: [CartItem], paymentMethodId: String) async -> Result<String, Error> {
        let urlString = "http://\(localHost):3000/payments/process-purchase"
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.badURL)
        }

        let purchaseRequest = PurchaseRequest(cartItems: cartItems, paymentMethodId: paymentMethodId)
        

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(purchaseRequest)

            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.serverError("Server error"))
            }
            
            if let result = try? JSONDecoder().decode([String: String].self, from: data),
               let message = result["message"] {
                return .success(message)
            } else {
                return .failure(NetworkError.badServerResponse)
            }
            
        } catch {
            return .failure(error)
        }
    }

    
    
}

