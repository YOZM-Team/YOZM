//
//  StudyProgressBar.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct StudyProgressBar: View {
    let progress: Double

    @State private var size: CGSize = .zero

    var body: some View {
        let clampedProgress = max(0.1, min(progress, 1.0))

        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.white)
            Capsule()
                .fill(Color.tertiaryNormal)
                .frame(width: size.width * clampedProgress)
                .overlay(
                    Image(.character)
                        .offset(x: 5),
                    alignment: .bottomTrailing
                )
        }
        .frame(maxHeight: 12)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            self.size = newValue
        }
    }
}

#Preview {
    @Previewable @State var progress = 0.0

    VStack {
        StudyProgressBar(progress: progress)

        HStack {
            Button("Increase") {
                withAnimation {
                    progress += 0.1
                }
            }
            Button("Reset") {
                withAnimation {
                    progress = 0.0
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
    .padding()
}
