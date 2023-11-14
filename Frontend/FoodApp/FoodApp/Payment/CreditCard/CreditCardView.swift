//
//  CreditCardView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//
//  Description: This view is responsible for presenting and handling user input for credit card details.
//  It's designed using SwiftUI and is linked to a CreditCardViewModel for data handling.

import SwiftUI

struct CreditCardView: View {
    // ViewModel to manage the credit card data and logic.
    @ObservedObject var viewModel: CreditCardViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Card Details")) {
                // Text field for entering credit card number.
                // It formats the input to a readable credit card format.
                TextField("Card Number", text: $viewModel.paymentMethod.cardNumber)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.paymentMethod.cardNumber) { oldValue, newValue in
                        viewModel.formatCreditCardNumber(newValue)
                    }

                // Text field for entering the card's expiration date.
                // Formats the input to MM/YY format.
                TextField("Expiration Date (MM/YY)", text: $viewModel.paymentMethod.expirationDate)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.paymentMethod.expirationDate) { oldValue, newValue in
                        viewModel.formatedExpirationDate(newValue)
                    }
                
                // Text field for entering the CVV of the card.
                // Ensures only 3 digits can be entered.
                TextField("CVV", text: $viewModel.paymentMethod.cvv)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.paymentMethod.cvv) { oldValue, newValue in
                        viewModel.formattedCvv(newValue)
                    }
            }
        }
    }
}

// Preview provider for SwiftUI previews in Xcode.
struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView(viewModel: CreditCardViewModel(apiService: APIService(), creditCard: CreditCard(cardNumber: "", expirationDate: "", cvv: "")))
    }
}
