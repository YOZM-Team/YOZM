//
//  TabView.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                modernTabView
            } else {
                legacyTabView
            }
        }
    }
    
    @available(iOS 18.0, *)
    private var modernTabView: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "map.fill", value: 0) {
                HomeView()
            }
            Tab("MyPage", systemImage: "person.fill", value: 1) {
                MyPageView()
            }
            Tab("Collection", systemImage: "star.fill", value: 2) {
                CollectionView()
            }
        }
    }
    
    private var legacyTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "map.fill")
                }
                .tag(0)
            
            MyPageView()
                .tabItem {
                    Label("MyPage", systemImage: "person.fill")
                }
                .tag(1)
            
            CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "star.fill")
                }
                .tag(2)
        }
    }
}
