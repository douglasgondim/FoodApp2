//
//  PaymentViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import SwiftUI
import Combine
import Stripe
import StripePaymentSheet

class PaymentViewModel: ObservableObject {
    var apiService : APIService
    var cartViewModel : CartViewModel
    
    @Published var currentPaymentMethod: PaymentType
    @Published var isPayButtonEnabled: Bool = false
    @ObservedObject var creditCardViewModel : CreditCardViewModel
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(apiService : APIService, cartViewModel: CartViewModel){
        self.apiService = apiService
        self.cartViewModel = cartViewModel
        currentPaymentMethod = .creditCard
        creditCardViewModel = CreditCardViewModel(apiService: apiService, creditCard: CreditCard(cardNumber: "", expirationDate: "", cvv: ""))
        setupSubscriptions()
        
//        creditCardViewModel.stubCreditCardAutoFill() // REMOVE
    }
    
    
    private func setupSubscriptions() {
        creditCardViewModel.$isPaymentMethodInfoComplete
            .receive(on: RunLoop.main)
            .sink { [weak self] complete in
                self?.isPayButtonEnabled = complete
            }
            .store(in: &cancellables)
    }
    
    func proccessPayment(cartItems : [CartItem]) async -> Result<String, PurchaseError>{
        switch currentPaymentMethod {
        case .creditCard:
            isLoading = true
            isPayButtonEnabled = false
            let response = await creditCardViewModel.processPayment(cartItems: cartItems)
            isLoading = false
            
            switch response {
            case .success(let message):
                alertMessage = message
                cartViewModel.cartHasBeenPaidFor = true
            case .failure(let error):
                alertMessage = error.localizedDescription
            }
            showAlert = true
            isPayButtonEnabled = true
          
            return response
        case.applePlay:
            return .failure(.processingFailed("Payments with Apple Pay are not supported yet."))
            
        }
    }
    
    
    
}
