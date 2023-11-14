//
//  PaymentView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//
//  Description: This file defines the PaymentView struct, which serves as the main view for
//  handling payments within the FoodApp. It uses SwiftUI for UI components and integrates with
//  the PaymentViewModel for processing logic.

import SwiftUI


// This view allows the user to choose a payment method and initiate the payment process.
struct PaymentView: View {
    @ObservedObject var viewModel: PaymentViewModel // The ViewModel that handles payment logic.
    @Environment(\.presentationMode) var presentationMode // For dismissing the view.
    
    var body: some View {
        VStack {
            // Picker to choose between different payment methods.
            Picker("Payment Type", selection: $viewModel.currentPaymentMethod) {
                Text("Credit Card").tag(PaymentType.creditCard)
                Text("Apple Pay").tag(PaymentType.applePay)
            }.pickerStyle(.segmented)
            
            // Displaying the appropriate view based on the selected payment method.
            switch viewModel.currentPaymentMethod {
            case .creditCard:
                CreditCardView(viewModel: viewModel.creditCardViewModel)
            case .applePay:
                Spacer()
                Text("Coming Soon!")
                    .font(.title)
                Spacer()
            }
            
            // Section for the Pay button.
            Section {
                Button(action: {
                    Task {
                        // Asynchronously process the payment when the button is tapped.
                        await viewModel.proccessPayment(cartItems: viewModel.cartViewModel.cartItems)
                    }
                }) {
                    Text("Pay")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(viewModel.isPayButtonEnabled ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.isPayButtonEnabled) // Disable button if not ready to pay.
                .contentShape(Rectangle())
                .padding()
                .opacity(viewModel.isPayButtonEnabled ? 1 : 0.5)
            }
        }
        .navigationTitle("Payment")
        .padding(.top, 10)
        
        // Alert to show payment status messages.
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Payment Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK"), action: {
                if viewModel.cartViewModel.cartHasBeenPaidFor {
                    presentationMode.wrappedValue.dismiss()
                }
            }))
        }
        
        // Overlay for displaying a loading indicator during payment processing.
        .overlay {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Processing Payment")
                        .padding()
                        .font(.headline)
                }
            }
        }
    }
}

// SwiftUI preview provider for PaymentView.
struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(viewModel: PaymentViewModel(apiService: APIService(), cartViewModel: CartViewModel(apiService: APIService())))
        }
    }
}
