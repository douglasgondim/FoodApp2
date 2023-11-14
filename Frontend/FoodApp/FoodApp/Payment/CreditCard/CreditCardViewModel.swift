//
//  CreditCardViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//
//  Description: This ViewModel handles the credit card data and payment processing logic.
//  It follows the MVVM pattern and conforms to the PaymentProcessorProtocol, with
//  Stripe API integration for payment processing.

import Foundation
import Stripe

class CreditCardViewModel: ObservableObject, PaymentProcessorProtocol {
    // API service for network requests, injected for modularity and testability.
    var apiService: APIService
    
    // Flag to track if payment method information is complete and valid.
    @Published var isPaymentMethodInfoComplete: Bool = false
    
    // Represents the payment method, observing changes to validate completeness.
    @Published var paymentMethod: CreditCard {
        didSet {
            isPaymentMethodInfoComplete = isPaymentMethodInfoCompleteChecker()
        }
    }
    
    // Function for stubbing credit card details, useful for testing.
    func stubCreditCardAutoFill() {
        paymentMethod = CreditCard(cardNumber: "4242 4242 4242 4242", expirationDate: "12/26", cvv: "123")
    }
    
    // Checks if the credit card information is complete and valid.
    func isPaymentMethodInfoCompleteChecker() -> Bool {
        return paymentMethod.cardNumber.filter { $0.isNumber }.count == 16 &&
        paymentMethod.expirationDate.filter { $0.isNumber }.count == 4 &&
        paymentMethod.cvv.filter { $0.isNumber }.count == 3
    }
    
    // Initializes the ViewModel with an API service and a credit card instance.
    init(apiService: APIService, creditCard: CreditCard) {
        self.apiService = apiService
        self.paymentMethod = creditCard
    }
    
    // Formats the credit card number to a readable 16-digit format.
    func formatCreditCardNumber(_ cardNumber: String) {
        let sanitizedNumber = cardNumber.filter { $0.isNumber }.prefix(16)
        let formattedString = sanitizedNumber.enumerated().map { (index, character) -> String in
            return index % 4 == 0 && index > 0 ? " \(character)" : String(character)
        }.joined()
        
        if paymentMethod.cardNumber != formattedString {
            paymentMethod.cardNumber = formattedString
        }
    }
    
    // Formats the expiration date to a MM/YY format.
    func formatedExpirationDate(_ expirationDate: String) {
        let sanitizedNumber = expirationDate.filter { $0.isNumber }.prefix(4)
        let formattedString = sanitizedNumber.enumerated().map { (index, character) -> String in
            if (index == 0 && Int(String(character))! > 1) ||
                (index == 1 && character == "0") ||
                (index == 1 && Int(String(character))! > 2) {
                return ""
            }
            return index == 2 ? "/\(character)" : String(character)
        }.joined()
        
        if paymentMethod.expirationDate != formattedString {
            paymentMethod.expirationDate = formattedString
        }
    }
    
    // Formats the CVV to ensure it is a 3-digit number.
    func formattedCvv(_ cvv: String) {
        let sanitizedNumber = cvv.filter { $0.isNumber }.prefix(3)
        let formattedString = String(sanitizedNumber)
        
        if paymentMethod.cvv != formattedString {
            paymentMethod.cvv = formattedString
        }
    }
    
    // Processes the payment for the cart items.
    func processPayment(cartItems: [CartItem]) async -> Result<String, PurchaseError> {
        guard let paymentMethodId = await createPaymentMethodParams(creditCard: paymentMethod) else {
            return .failure(.processingFailed("Failed to create payment method."))
        }
        
        let result = await apiService.processPurchase(cartItems, paymentMethodId: paymentMethodId)
        switch result {
        case .success(let message):
            return .success(message)
        case .failure(let error):
            return .failure(.processingFailed(error.localizedDescription))
        }
    }
    
    // Parses the expiration date string into month and year.
    func parseExpirationDate(_ dateStr: String) -> (month: NSNumber?, year: NSNumber?) {
        let components = dateStr.split(separator: "/").map(String.init)
        
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]) else {
            return (nil, nil)
        }
        
        let formattedYear = 2000 + year
        return (NSNumber(value: month), NSNumber(value: formattedYear))
    }
    
    // Creates Stripe payment method parameters.
    func createPaymentMethodParams(creditCard: CreditCard) async -> String? {
        let (month, year) = parseExpirationDate(creditCard.expirationDate)
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = creditCard.cardNumber.filter { $0.isNumber }
        cardParams.expMonth = month
        cardParams.expYear = year
        cardParams.cvc = creditCard.cvv
        
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        
        return await withCheckedContinuation { continuation in
            STPAPIClient.shared.createPaymentMethod(with: paymentMethodParams) { paymentMethod, error in
                if let error = error {
                    print("Error creating payment method: \(error)")
                    continuation.resume(returning: nil)
                } else if let paymentMethodId = paymentMethod?.stripeId {
                    continuation.resume(returning: paymentMethodId)
                }
            }
        }
    }
}
