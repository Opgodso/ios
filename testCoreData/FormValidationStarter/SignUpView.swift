//
//  SignUpView.swift
//  FormValidationStarter
//
//  Created by 羅壽之 on 2024/12/16.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var accountForm = AccountForm()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Enter email", text: $accountForm.email)
                        .autocapitalization(.none)
                    RequiredText(text: "Legal email format", isStrikeThrough: accountForm.emailValidate)
                    
                    SecureField("Enter password", text: $accountForm.password)
                    RequiredText(text: "At least 6 characters", isStrikeThrough: accountForm.passwordLengthValidate)
                    RequiredText(text: "At least one uppercase letter", isStrikeThrough: accountForm.passwordUppercaseValidate)
                
                    SecureField("Re-enter password", text: $accountForm.passwordConfirm)
                    RequiredText(text: "Should be the same", isStrikeThrough: accountForm.passwordConfirmValidate)
                } // Form
                
                Button {
                    // send the registration form to the server
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Submit")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(30)
                .padding(.top, 10)
            } // VStack
            
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        } // NavigationView
    }
    
}

struct RequiredText: View {
    var text: String
    var isStrikeThrough: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.square")
            Text(text)
                .foregroundColor(.secondary)
                .strikethrough(isStrikeThrough)
        }
    }
}
