//
//  PaymentViewModel.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//

import SwiftUI

class PaymentViewModel: ObservableObject {
    @Published var currentPaymentMethod: PaymentType = .creditCard
    

}
