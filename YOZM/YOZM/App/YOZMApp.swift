//
//  YOZMApp.swift
//  YOZM
//
//  Created by 최희진 on 8/9/25.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YOZMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            MainTabView()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .background:
                GoogleAnalyticsService.shared.appBackgrounded()
            case .active:
                GoogleAnalyticsService.shared.appForegrounded()
            default:
                break
            }
        }
    }
}

#Preview {
    MainView()
}
