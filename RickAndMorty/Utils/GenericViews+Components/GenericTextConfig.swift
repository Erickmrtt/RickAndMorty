//
//  GenericTextConfig.swift
//  RickAndMorty
//
//  Created by erick on 23/06/24.
//

import SwiftUI

struct GenericTextConfig: ViewModifier {
    var accessibilityText: String? = ""
    var fontSize: CGFloat = 16
    var customFont: String = "MuseoSans-500"
    var color: Color = Color.clear
    var paddingTop: CGFloat? = 0
    var paddingLeading: CGFloat? = 0
    var paddingBottom: CGFloat? = 0
    var paddingTrailing: CGFloat? = 0
    var textAlignment: TextAlignment? = .leading

    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(Font.custom(customFont, size: fontSize))
            .accessibility(label: Text(accessibilityText ?? ""))
            .padding(EdgeInsets(top: paddingTop ?? 0, leading: paddingLeading ?? 0 , bottom: paddingBottom ?? 0, trailing: paddingTrailing ?? 0))
            .multilineTextAlignment(textAlignment ?? .leading)
    }
}
