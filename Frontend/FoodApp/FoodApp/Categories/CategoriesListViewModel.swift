//
//  CategoriesViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//
//  Description: This file defines the CategoriesListViewModel class, which is responsible for
//  managing the categories data and interactions in the FoodApp. It uses Combine for reactive programming.

import Foundation
import Combine

// The CategoriesListViewModel class provides functionalities to fetch, store, and manage categories.
class CategoriesListViewModel: ObservableObject {
    @Published var categories: [Category] = [] // Holds the list of categories.
    @Published var selectedCategory: Category? = nil // Tracks the currently selected category.
    @Published var isNavigationActive: Bool = false // Flag to control navigation state.
    @Published var errorMessage: String? // Holds any error message that may occur during data fetching.

    private let apiService: APIService // API service for fetching category data.
    private let cartViewModel: CartViewModel // ViewModel for managing the shopping cart.

    private var cancellables: Set<AnyCancellable> = [] // Stores Combine subscriptions.
    
    // Initialize with dependencies.
    init(apiService: APIService, cartViewModel: CartViewModel) {
        self.apiService = apiService
        self.cartViewModel = cartViewModel
        loadCategories() // Load categories upon initialization.
    }
    
    // Function to return the API service instance.
    func getAPIService() -> APIService {
        return apiService
    }
    
    // Function to return the CartViewModel instance.
    func getCartViewModel() -> CartViewModel {
        return cartViewModel
    }
    
    // Function to fetch categories from the API and update the published property.
    func loadCategories() {
        categories.removeAll()
        apiService.fetchCategories()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] categories in
                // Update the categories list with fetched data.
                self?.categories = categories
            })
            .store(in: &cancellables)
    }
    
    // Function to handle category selection and update navigation state.
    func selectCategory(_ category: Category) {
        selectedCategory = category
        isNavigationActive = true
    }
    
    // Function to reset the selected category and navigation state.
    func resetSelectedCategory() {
        selectedCategory = nil
        isNavigationActive = false
    }
}
