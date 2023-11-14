//
//  CreditCardViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import Foundation
import Stripe

class CreditCardViewModel: ObservableObject, PaymentProcessorProtocol {
    var apiService : APIService
    
    @Published var isPaymentMethodInfoComplete: Bool = false
    
    typealias PaymentMethodType = CreditCard
    
    @Published var paymentMethod : CreditCard {
        didSet {
            isPaymentMethodInfoComplete = isPaymentMethodInfoCompleteChecker()
        }
    }
    
    func stubCreditCardAutoFill(){
        paymentMethod = CreditCard(cardNumber: "4242 4242 4242 4242", expirationDate: "12/26", cvv: "123")
    }
    
    func isPaymentMethodInfoCompleteChecker() -> Bool {
        return paymentMethod.cardNumber.filter{ $0.isNumber }.count  == 16 &&
        paymentMethod.expirationDate.filter { $0.isNumber }.count == 4 &&
        paymentMethod.cvv.filter { $0.isNumber }.count == 3
        
    }
    
    init(apiService: APIService, creditCard : CreditCard){
        self.apiService = apiService
        self.paymentMethod = creditCard
    }
    

    func formatCreditCardNumber(_ cardNumber: String) {
        // Remove non-numeric characters and limit size to 16 digits
        let sanitizedNumber = cardNumber.filter { $0.isNumber }.prefix(16)
        
        // Format as XXXX XXXX XXXX XXXX
        let formattedString = sanitizedNumber.enumerated().map { (index, character) -> String in
            return index % 4 == 0 && index > 0 ? " \(character)" : String(character)
        }.joined()
        
        if paymentMethod.cardNumber != formattedString {
            paymentMethod.cardNumber = formattedString
        }
        
        
    }
    

    func formatedExpirationDate(_ expirationDate: String) {
        // Remove non-numeric characters and limit size to 4 digits
        let sanitizedNumber = expirationDate.filter { $0.isNumber }.prefix(4)
        
        // Format as MM/YY
        let formattedString = sanitizedNumber.enumerated().map { (index, character) -> String in
            if (index == 0 && Int(String(character))! > 1) ||
                (index == 1 && character == "0") ||
                (index == 1 &&  Int(String(character))! > 2)
            {
                return ""
            }
            return index == 2 ? "/\(character)" : String(character)
        }.joined()
        
        if paymentMethod.expirationDate != formattedString {
            paymentMethod.expirationDate = formattedString
        }

    }
    

    func formattedCvv(_ cvv : String) {
        // Remove non-numeric characters and limit size to 3 digits
        let sanitizedNumber = cvv.filter { $0.isNumber }.prefix(3)
        
        // Format as XXX
        let formattedString = String(sanitizedNumber)

        if paymentMethod.cvv != formattedString {
            paymentMethod.cvv = formattedString
        }
 
    }
    
    func processPayment(cartItems : [CartItem]) async -> Result<String, PurchaseError> {
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
    
    func createPaymentMethodParams(creditCard : CreditCard) async -> String? {
        let (month, year) = parseExpirationDate(creditCard.expirationDate)
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = creditCard.cardNumber.filter( {$0.isNumber })
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
