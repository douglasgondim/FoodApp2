//
//  CreditCardModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import Foundation

struct CreditCard : PaymentMethod {
    var type: PaymentType
    var cardNumber: String
    var expirationDate: String
    var cvv: String
}

