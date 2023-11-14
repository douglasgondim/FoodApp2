//
//  PaymentModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//
//  Description: This file contains protocols and models related to payment processing in the app.
//  It defines how payment methods are structured and how they interact with the payment processor.

import Foundation

// Protocol defining the basic structure of a payment method.
// This protocol ensures each payment method has a specific type.
protocol PaymentMethodProtocol {
    var type: PaymentType { get }
}

// Protocol for classes that process payments.
// This protocol requires an observable object that can handle different types of payment methods.
// It ensures that any payment processor can handle a payment process with cart items and handle errors.
protocol PaymentProcessorProtocol: ObservableObject {
    associatedtype PaymentMethodType: PaymentMethodProtocol
    var paymentMethod: PaymentMethodType { get set }
    var isPaymentMethodInfoComplete: Bool { get }
    func processPayment(cartItems: [CartItem]) async -> Result<String, PurchaseError>
}

// Enum representing the types of payment methods supported in the app.
// This allows for easy expansion of payment types in the future.
enum PaymentType {
    case creditCard
    case applePay
}

// Enum representing the types of errors that can occur during the purchase process.
enum PurchaseError: Error {
    case processingFailed(String) // Error case for failed processing with an error message.
}

// Struct representing a purchase request.
// Encodable to JSON for potential API requests, containing cart items and payment method details.
struct PurchaseRequest: Codable {
    let cartItems: [CartItem]
    let paymentMethodId: String
}
