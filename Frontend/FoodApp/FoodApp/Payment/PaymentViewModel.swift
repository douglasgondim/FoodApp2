//
//  PaymentViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//
//  Description: This file contains the PaymentViewModel class which handles the logic
//  for processing payments within the app. It integrates with external services,
//  manages payment methods, and handles UI updates based on payment processing state.

import SwiftUI
import Combine
import Stripe
import StripePaymentSheet

// The PaymentViewModel class is responsible for handling payment logic in the app.
// It keeps track of the current payment method, payment status, and integrates with the Stripe SDK.
class PaymentViewModel: ObservableObject {
    var apiService: APIService          // Service for making API calls.
    var cartViewModel: CartViewModel    // ViewModel for the shopping cart.
    
    // Observable properties to update the view in real-time.
    @Published var currentPaymentMethod: PaymentType // The current selected payment method.
    @Published var isPayButtonEnabled: Bool = false  // Controls the 'Pay' button enabled state.
    @ObservedObject var creditCardViewModel: CreditCardViewModel // ViewModel for credit card information.
    
    // Properties for alert presentation.
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    // Loading state to show activity indicator during payment processing.
    @Published var isLoading = false
    
    // Subscription set for Combine publishers.
    private var cancellables = Set<AnyCancellable>()
    
    // Initialization with required services and default settings.
    init(apiService: APIService, cartViewModel: CartViewModel) {
        self.apiService = apiService
        self.cartViewModel = cartViewModel
        currentPaymentMethod = .creditCard
        creditCardViewModel = CreditCardViewModel(apiService: apiService, creditCard: CreditCard(cardNumber: "", expirationDate: "", cvv: ""))
        setupSubscriptions()
        
        // Pre-fill valid credit card information for testing purposes (remove for production).
       // creditCardViewModel.stubCreditCardAutoFill()
    }
    
    // Sets up subscriptions to listen to changes in the credit card view model.
    private func setupSubscriptions() {
        creditCardViewModel.$isPaymentMethodInfoComplete
            .receive(on: RunLoop.main)
            .sink { [weak self] complete in
                self?.isPayButtonEnabled = complete
            }
            .store(in: &cancellables)
    }
    
    // Processes the payment based on the current payment method.
    func proccessPayment(cartItems: [CartItem]) async -> Result<String, PurchaseError> {
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
        case .applePay:
            // Placeholder for Apple Pay implementation.
            return .failure(.processingFailed("Payments with Apple Pay are not supported yet."))
        }
    }
}
