//
//  ErrorView.swift
//  RickAndMorty
//
//  Created by erick on 23/06/24.
//

import SwiftUI
import Foundation

struct ErrorUIView: View {

    var reload: () -> Void

    var body: some View {
        VStack {
            Image("error")
                .resizable()
                .frame(width: 90, height: 90)
                .padding(.bottom, 32)
            Text("smgWrong".localized())
                .frame(width: 256, height: 36)
                .font(Font.custom("MuseoSans-700", size: 24))
                .foregroundColor(Color(hex: 0xD7464D))
                .padding(.bottom, 24)
                .accessibility(label: Text("smgWrong".localized()))
            Text("opsAlgoDeuErradoMsg")
                .accessibility(label: Text("opsAlgoDeuErradoMsg"))
                .frame(width: 305, height: 72)
                .font(Font.custom("MuseoSans-500", size: 16))
                .foregroundColor(Color(hex: 0x525457))
                .multilineTextAlignment(.center)
                .padding(.bottom, 35)
            Button(action: {
                self.reload()
            }) {
                Text("tentarNovamente")
                    .accessibility(label: Text("tentarNovamente"))
                    .foregroundColor(Color(hex: 0xD7464D))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: 0xD7464D), lineWidth: 2)
                    )
            }
            .frame(height: 43)
            .frame(maxWidth: .infinity)
            .padding([.horizontal], 16)

        }
    }
}
