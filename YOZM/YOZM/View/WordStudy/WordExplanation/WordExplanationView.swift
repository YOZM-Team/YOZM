//
//  WordExplanationView.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct WordExplanationView: View {
    @State private var viewModel: WordExplanationViewModel
    
    init(viewModel: WordExplanationViewModel = WordExplanationViewModel()) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            
            VStack {
                Text(viewModel.word.word)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.blackNormal)
                
                Text(viewModel.word.pronunciation)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.blackNormal)
            }
            
            Text(viewModel.word.meaning)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.blackNormal)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
        }
        .padding(.vertical, Spacing.lg)
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: 480)
        .background(StudyCardBackground())
        .task {
            try? await Task.sleep(for: .seconds(3))
            viewModel.finishAction?()
        }
    }
}

#Preview {
    WordExplanationView()
}
