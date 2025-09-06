//
//  HomeView.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import CloudKit
import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Home")
            .onAppear {
                GoogleAnalyticsService.shared.setCurrentScreen(.home)
                // TODO: Set progress percent
                GoogleAnalyticsService.shared.screenHome(
                    userProgressPercent: 0.0
                )
            }
    }
}

#Preview {
    HomeView()
}
