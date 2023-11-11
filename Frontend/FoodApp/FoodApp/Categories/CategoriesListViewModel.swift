//
//  CategoriesViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 10/11/23.
//


import Foundation
import Combine

class CategoriesListViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category? = nil
    @Published var isNavigationActive: Bool = false
    
    private let apiService: APIService
    private let cartViewModel : CartViewModel
    
    private var cancellables: Set<AnyCancellable> = []

    
    init(apiService: APIService, cartViewModel : CartViewModel) {
        self.apiService = apiService
        self.cartViewModel = cartViewModel
        loadCategories()
    }
    
    func getAPIService() -> APIService {
        return apiService
    }
    
    func getCartViewModel() -> CartViewModel {
        return cartViewModel
    }
    
    func loadCategories() {
        apiService.fetchCategories()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] categories in
                self?.categories = categories
            })
            .store(in: &cancellables)
    }
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
        isNavigationActive = true
    }
    
    func resetSelectedCategory(){
        selectedCategory = nil
        isNavigationActive = false
    }
}
