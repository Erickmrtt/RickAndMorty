//
//  InputTextView.swift
//  RickAndMorty
//
//  Created by erick on 25/06/24.
//

import SwiftUI

struct InputTextView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.footnote)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.bold)
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .cornerRadius(8)
            } else {
                TextField(placeholder, text: $text)
                    .cornerRadius(8)
            }
            Divider()
        }
    }

}

#Preview {
    InputTextView(text: .constant(""), title: "Email Adress", placeholder: "example@gmail.com")
}
