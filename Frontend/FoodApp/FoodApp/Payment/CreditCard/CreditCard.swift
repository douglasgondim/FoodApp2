//
//  CreditCardModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import Foundation

struct CreditCard : PaymentMethodProtocol {
    let type: PaymentType = .creditCard
    var cardNumber: String
    var expirationDate: String
    var cvv: String

  
}

