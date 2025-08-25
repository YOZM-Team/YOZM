//
//  PronunciationScoreView.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

import SwiftUI

struct PronunciationScoreView: View {
    @State var reference: String = "안녕하세요"
    @State var hypothesis: String = "안녕하세요"

    private let pronunciationScoreService = PronunciationScoreService.shared

    private var score: Double {
        pronunciationScoreService.scorePronunciation(
            reference: reference,
            hypothesis: hypothesis
        )
    }

    var body: some View {
        VStack {
            scoreText

            HStack {
                referenceTextField
                hypothesisTextField
            }
        }
        .padding()
    }

    private var scoreText: some View {
        VStack(alignment: .leading) {
            Text("점수")
                .font(.headline)
            Text(
                String(format: "%.0lf점", score * 100)
            )
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var referenceTextField: some View {
        VStack(alignment: .leading) {
            Text("원본")
                .font(.headline)
            TextField("Reference", text: $reference)
        }
        .padding()
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 16)
        )
    }

    private var hypothesisTextField: some View {
        VStack(alignment: .leading) {
            Text("비교")
                .font(.headline)
            TextField("Hypothesis", text: $hypothesis)
        }
        .padding()
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 16)
        )
    }
}

#Preview {
    PronunciationScoreView()
}
