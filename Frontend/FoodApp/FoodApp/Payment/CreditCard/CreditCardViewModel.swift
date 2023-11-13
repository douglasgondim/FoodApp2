//
//  CreditCardViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import Foundation
class CreditCardViewModel: ObservableObject, PaymentProcessor {
    @Published var creditCard = CreditCard(type: .creditCard, cardNumber: "", expirationDate: "", cvv: "")
    
    func formatCreditCardNumber(_ cardNumber: String){
        // Remove non-numeric characters and limit size to 16 digits
        let sanitizedNumber = cardNumber.filter { $0.isNumber }.prefix(16)
        
        // Format as XXXX XXXX XXXX XXXX
        let formattedString = sanitizedNumber.enumerated().map { (index, character) -> String in
            return index % 4 == 0 && index > 0 ? " \(character)" : String(character)
        }.joined()
        
        creditCard.cardNumber = formattedString
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
        
        
        creditCard.expirationDate = formattedString
    }
    
    func formattedCvv(_ expirationDate : String){
        // Remove non-numeric characters and limit size to 3 digits
        let sanitizedNumber = expirationDate.filter { $0.isNumber }.prefix(3)
        
        // Format as XXX
        let formattedString = String(sanitizedNumber)
        
        creditCard.cvv = formattedString
    }
    
    func processPayment() {
        print("Processing payment")
    }
    
    
}
