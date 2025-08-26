//
//  HomeView.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import SwiftUI
import CloudKit

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Home")
//            .onAppear{
//                Task{
//                    let _ = try await CloudKitService.shared.fetchAndPrintRecord(recordIDString: "CCE66256-9702-4974-B38E-5F3F5B8C6A54")
//        
//                    let url = try await CloudKitService.shared.fetchAudioData(recordIDString: "CCE66256-9702-4974-B38E-5F3F5B8C6A54", audioType: .sentence)
//                    
//                    let urls = try await CloudKitService.shared.fetchAudioDatas(recordIDString: "CCE66256-9702-4974-B38E-5F3F5B8C6A54")
//                    print(url, urls)
//                }
//            }
    }
}

#Preview {
    HomeView()
}
