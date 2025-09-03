//
//  StudyNextButtonStyle.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct StudyNextButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .bold()
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background {
                Capsule()
                    .fill(
                        configuration.isPressed
                            ? .greenNormalHover : .greenNormal
                    )
                    .shadow(
                        color: configuration.isPressed
                            ? Color(hex: "5A8E1C") : Color(hex: "7CB736"),
                        radius: 0,
                        x: 2,
                        y: 6
                    )
            }
            .opacity(isEnabled ? 1.0 : 0.4)
    }
}

#Preview {
    Button("Next") {}
        .buttonStyle(StudyNextButtonStyle())
}
