//
//  HomeView.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Home")
    }
}

#Preview {
    HomeView()
}
