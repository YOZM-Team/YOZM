//
//  GoogleAnalyticsView.swift
//  YOZM
//
//  Created by 정희균 on 9/4/25.
//

import FirebaseAnalytics
import SwiftUI

struct GoogleAnalyticsView: View {
    var body: some View {
        Button("Test") {
            GoogleAnalyticsService.shared.inputSentenceTestStarted(wordId: 0)
        }
        .onAppear {
            GoogleAnalyticsService.shared.setCurrentScreen(.chapter)
        }
    }
}

#Preview {
    GoogleAnalyticsView()
}
