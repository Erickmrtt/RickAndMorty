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
    @EnvironmentObject var networkMonitor: NetworkMonitor
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Image("logoImage".localized())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 150)
                        .padding(.vertical, 32)
                    if viewModel.showErrorMessage {
                        Text("passwordEmailWrongMsg".localized())
                            .modifier(GenericTextConfig(accessibilityText: "passwordEmailWrongMsg".localized(),fontSize: 14,color: .red, fontWeight: .semibold))
                    }
                    VStack {
                        InputTextView(text: $viewModel.userEmail, title: "txtFieldEmail".localized(), placeholder: "txtFieldEmailPlaceholder".localized())
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.none)
                        InputTextView(text: $viewModel.userPassword, title: "txtFieldPassword".localized(), placeholder: "txtFieldPasswordPlaceholder".localized(), isSecureField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    Button(action: {
                        Task { try await viewModel.loginValidation() }
                    }) {
                        Text("btnSignIn".localized())
                            .modifier(GenericTextConfig(accessibilityText: "btnSignIn".localized(),fontSize: 16,color: .white, fontWeight: .semibold))
                            .font(.headline)
                            .padding()
                            .opacity(buttonOpacity)
                            .disabled(!viewModel.formIsInvalid)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }.background(.teal)
                        .cornerRadius(8)
                        .padding(.top, 38)
                        .navigationDestination(isPresented: $viewModel.isLoginSuccess) {
                            CharacterView().environmentObject(networkMonitor).navigationBarBackButtonHidden(true)
                        }
                    Spacer()
                    NavigationLink {

                    } label: {
                        Text("btnSignUp".localized())
                            .modifier(GenericTextConfig(accessibilityText: "btnSignUp".localized(),fontSize: 12,color: .teal, paddingBottom: 5,fontWeight: .semibold))
                            .font(.footnote)
                    }

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
