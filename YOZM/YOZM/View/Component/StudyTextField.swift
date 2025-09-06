//
//  StudyTextField.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct StudyTextField: View {
    @Binding var text: String
    let correctText: String
    let isCorrect: Bool

    var body: some View {
        TextField("", text: $text)
            .multilineTextAlignment(.center)
            .foregroundStyle(.blackNormal)
            .padding()
            .overlay {
                HStack {
                    Spacer()
                    if isCorrect {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.greenDark)
                            .padding(Spacing.xs)
                    } else {
                        Image(systemName: "xmark")
                            .foregroundStyle(.tertiaryNormal)
                            .padding(Spacing.xs)
                    }
                }
                Text(correctText)
                    .foregroundStyle(.clear)
                    .padding(.top, Spacing.xs)
                    .overlay(
                        GeometryReader { geo in
                            Path { path in
                                path.move(to: .zero)
                                path.addLine(
                                    to: CGPoint(x: geo.size.width, y: 0)
                                )
                            }
                            .stroke(
                                .blackNormal,
                                style: StrokeStyle(lineWidth: 1, dash: [4, 1])
                            )
                        }
                        .frame(height: 1),
                        alignment: .bottom
                    )
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .strokeBorder(.stroke)
            }
    }
}

#Preview {
    @Previewable @State var text = ""

    StudyTextField(text: $text, correctText: "느좋", isCorrect: true)
    StudyTextField(text: $text, correctText: "느좋", isCorrect: false)
}
