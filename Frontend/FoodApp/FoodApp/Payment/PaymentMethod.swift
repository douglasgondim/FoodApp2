//
//  PaymentModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import Foundation

protocol PaymentMethodProtocol {
    var type: PaymentType { get }
    
}

protocol PaymentProcessorProtocol: ObservableObject {
    associatedtype PaymentMethodType : PaymentMethodProtocol
    var paymentMethod : PaymentMethodType { get set }
    var isPaymentMethodInfoComplete : Bool { get }
    func processPayment(cartItems : [CartItem]) async -> Result<String, PurchaseError>

}

enum PaymentType {
    case creditCard
    case applePlay

}

enum PurchaseError: Error {
    case processingFailed(String)
}

struct PurchaseRequest: Codable {
    let cartItems: [CartItem]
    let paymentMethodId: String 

 
}


