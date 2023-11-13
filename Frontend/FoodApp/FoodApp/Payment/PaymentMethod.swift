//
//  PaymentModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import Foundation

protocol PaymentMethod {
    var type: PaymentType { get set }
}

protocol PaymentProcessor {
    func processPayment()

}

enum PaymentType {
    case creditCard
    case applePlay

 
}
