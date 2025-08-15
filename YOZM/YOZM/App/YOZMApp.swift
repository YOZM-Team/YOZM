//
//  YOZMApp.swift
//  YOZM
//
//  Created by 최희진 on 8/9/25.
//

import SwiftUI

@main
struct YOZMApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

#Preview {
    MainView()
}
