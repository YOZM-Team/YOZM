//
//  StudyCircleButtonStyle.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct StudyCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .foregroundStyle(.black)
            .background {
                Circle()
                    .fill(
                        configuration.isPressed
                            ? .tertiaryHover : .tertiaryNormal
                    )
                    .frame(width: 48, height: 48)
                    .shadow(
                        color: configuration.isPressed
                            ? Color(hex: "996E0A") : Color(hex: "B07D07"),
                        radius: 0,
                        x: 3,
                        y: 3
                    )
            }
    }
}

#Preview {
    Button {} label: {
        Image(systemName: "play")
    }
    .buttonStyle(StudyCircleButtonStyle())
}
