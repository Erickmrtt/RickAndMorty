//
//  LoginView.swift
//  RickAndMorty
//
//  Created by erick on 25/06/24.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding(.vertical, 32)
                VStack {
                    InputTextView(text: $viewModel.userEmail, title: "Email Address", placeholder: "email@example.com")
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                    InputTextView(text: $viewModel.userPassword, title: "Password", placeholder: "Enter your password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Button(action: {
                    Task { try await viewModel.loginValidation() } 
                }) {
                    Text("Sign in")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .opacity(buttonOpacity)
                        .disabled(!viewModel.formIsInvalid)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)

                }
                .background(.teal)
                .cornerRadius(8)
                .padding(.top, 38)

                Spacer()
                NavigationLink {

                } label: {
                    Text("Don't have an account? Sign up")
                        .font(.footnote)
                        .foregroundColor(.teal)
                        .padding(.bottom, 5)
                }

            }
        }
    }
    var buttonOpacity: Double {
      return viewModel.formIsInvalid ? 1 : 0.5
    }
}

#Preview {
    LoginView()
}


struct ValidationPreferenceKey : PreferenceKey {
   static var defaultValue: [Bool] = []

   static func reduce(value: inout [Bool], nextValue: () -> [Bool]) {
      value += nextValue()
   }
}
struct ValidationModifier : ViewModifier  {
   let validation : () -> Bool
   func body(content: Content) -> some View {
         content
            .preference(
               key: ValidationPreferenceKey.self,
               value: [validation()]
            )
      }
   }

extension TextField   {
   func validate(_ flag : @escaping ()-> Bool) -> some View {
      self
         .modifier(ValidationModifier(validation: flag))
   }
}

extension SecureField   {
   func validate(_ flag : @escaping ()-> Bool) -> some View {
      self
         .modifier(ValidationModifier(validation: flag))
   }
}

struct TextFormView<Content : View> : View {
   @State var validationSeeds : [Bool] = []
   @ViewBuilder var content : (( @escaping () -> Bool)) -> Content
   var body: some View {
         content(validate)
         .onPreferenceChange(ValidationPreferenceKey.self) { value in
            validationSeeds = value
         }
   }

   private func validate() -> Bool {
      for seed in validationSeeds {
         if !seed { return false}
      }
      return true
   }
}
