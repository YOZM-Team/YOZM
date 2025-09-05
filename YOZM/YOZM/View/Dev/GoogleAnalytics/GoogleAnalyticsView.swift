//
//  GoogleAnalyticsView.swift
//  YOZM
//
//  Created by 정희균 on 9/4/25.
//

import SwiftUI
import FirebaseAnalytics

struct GoogleAnalyticsView: View {
    var body: some View {
        Button("Test") {
            Analytics.logEvent("timeline", parameters: nil)
        }
    }
}

#Preview {
    GoogleAnalyticsView()
}
