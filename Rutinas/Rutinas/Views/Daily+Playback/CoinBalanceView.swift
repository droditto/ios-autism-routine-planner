//
//  CoinBalanceView.swift
//  Rutinas
//

import SwiftUI
import SwiftData

struct CoinBalanceView: View {
    @Binding var user: User
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss)    private var dismiss
    
    @FocusState private var amountFieldIsFocused: Bool
    
    @State private var inputAmount: String = ""
    @State private var showConfirmation = false
    
    private var amount: Int? {
        Int(inputAmount)
    }
    
    private var isValidAmount: Bool {
        guard let amt = amount else { return false }
        return amt > 0 && amt <= user.coinBalance
    }
    
    var body: some View {
        Group {
            VStack {
                // Dismiss
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.bottom)
                
                // Current balance
                VStack {
                    Text("Your coins:")
                        .font(.headline)
                    HStack {
                        Text("\(user.coinBalance)")
                        Image(systemName: "sparkles")
                    }
                    .font(user.preferredFont(textStyle: .headline))
                    .foregroundColor(.yellow)
                }
                
                // Spend text field
                VStack {
                    Text("How many do you want to spend?")
                        .font(user.preferredFont(textStyle: .title3))
                    
                    TextField("0", text: $inputAmount)
                        .keyboardType(.numberPad)
                        .focused($amountFieldIsFocused)
                        .font(user.preferredFont(textStyle: .title).bold())
                        .multilineTextAlignment(.center)
                        .frame(width: 150)
                }
                .padding(.vertical)
                
                // Math tower preview
                VStack(alignment: .trailing) {
                    if let amt = amount, amt > 0 {
                        
                        // Minuendo
                        HStack(spacing: 4) {
                            Text("\(user.coinBalance)")
                            Image(systemName: "sparkles")
                        }
                        .font(user.preferredFont(textStyle: .title3).bold())
                        .foregroundColor(.yellow)
                        
                        // Sustraendo
                        HStack(spacing: 4) {
                            Text("- \(amt)")
                            Image(systemName: "sparkles")
                        }
                        .font(user.preferredFont(textStyle: .title3).bold())
                        .foregroundColor(.red)
                        
                        Divider()
                            .frame(height: 2)
                            .background(Color.primary)
                        
                        // Resto
                        if let amt = amount, amt > 0 {
                            let rem = user.coinBalance - amt
                            HStack(spacing: 4) {
                                Text("\(rem)")
                                Image(systemName: "sparkles")
                            }
                            .font(user.preferredFont(textStyle: .title3).bold())
                            .foregroundColor(.orange)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                                
                // Confirmation button
                Button {
                    showConfirmation = true
                } label: {
                    Text("Confirm")
                        .font(user.preferredFont(textStyle: .title2).bold())
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(isValidAmount ? .accentColor : Color(.secondarySystemFill))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .disabled(!isValidAmount)
                .alert("Spend Coins?", isPresented: $showConfirmation) {
                    Button("Cancel", role: .cancel) {}
                    Button("Yes", role: .destructive) {
                        commitSpend()
                    }
                } message: {
                    Text("Are you sure you want to spend \(inputAmount) coins?")
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    amountFieldIsFocused = false
                }
            }
        }
    }
    
    private func commitSpend() {
        guard let amt = amount, user.canSpend(amt) else { return }
        user.spend(amt)
        dismiss()
    }
}

#Preview {
    @Previewable @State var user : User = User(coinBalance: 250)
    CoinBalanceView(user: $user)
}
