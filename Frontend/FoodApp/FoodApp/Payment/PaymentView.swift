//
//  PaymentView.swift
//  FoodApp
//
//  Created by Douglas Gondim on 12/11/23.
//
import SwiftUI


struct PaymentView: View {
    @ObservedObject var viewModel: PaymentViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            Picker("Payment Type", selection: $viewModel.currentPaymentMethod) {
                Text("Credit Card").tag(PaymentType.creditCard)
                Text("Apple Pay").tag(PaymentType.applePlay)
            }.pickerStyle(.segmented)
            
            switch viewModel.currentPaymentMethod {
            case .creditCard:
                CreditCardView(viewModel: viewModel.creditCardViewModel)
            case .applePlay:
                Spacer()
                Text("Coming Soon!")
                    .font(.title)
                Spacer()
            }
            
            Section {
                Button(action: {
                    Task {
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
                .disabled(!viewModel.isPayButtonEnabled)
                .contentShape(Rectangle())
                .padding()
                .opacity(viewModel.isPayButtonEnabled ? 1 : 0.5)
                
                
                
            }
        }
        .navigationTitle("Payment")
        .padding(.top, 10)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Payment Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK"), action: {
                presentationMode.wrappedValue.dismiss()}))
        }
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



struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(viewModel: PaymentViewModel(apiService: APIService(), cartViewModel: CartViewModel(apiService: APIService())))
        }
    }
}

