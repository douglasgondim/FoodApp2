//
//  APIService.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//
//  Description: This file contains the APIService class which is responsible for handling all
//  network requests for the FoodApp. It includes functions for fetching products, categories,
//  and processing purchases.

import Foundation
import Combine

// Enum defining possible network errors.
enum NetworkError: Error {
    case badURL
    case serverError(String)
    case dataProcessingError
    case badServerResponse
}

// APIService class for handling network requests.
class APIService {
    let localHost = "localhost" // Localhost URL for server.

    // Fetch products for a given category.
    func fetchProductsForCategory(for category: String) -> AnyPublisher<[Product], Error> {
        // Construct URL for the request.
        guard let url = URL(string: "http://\(localHost):3000/categories/\(category)/products") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // Create and perform network request.
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                // Check for HTTP status code 200 (OK).
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
    
    // Fetch all categories.
    func fetchCategories() -> AnyPublisher<[Category], Error> {
        // Construct URL for the request.
        guard let url = URL(string: "http://\(localHost):3000/categories") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // Create and perform network request.
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                // Check for HTTP status code 200 (OK).
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
    
    // Process a purchase request.
    func processPurchase(_ cartItems: [CartItem], paymentMethodId: String) async -> Result<String, Error> {
        let urlString = "http://\(localHost):3000/payments/process-purchase"
        
        // Construct URL for the request.
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.badURL)
        }

        let purchaseRequest = PurchaseRequest(cartItems: cartItems, paymentMethodId: paymentMethodId)
        
        // Perform the request asynchronously.
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(purchaseRequest)

            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP status code in the 200-299 range.
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.serverError("Server error"))
            }
            
            // Decode response and return the result.
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
