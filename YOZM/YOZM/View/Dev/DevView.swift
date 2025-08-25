//
//  DevView.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

import SwiftUI

struct DevView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Audio Player") {
                    AudioPlayerView()
                }
                NavigationLink("Speech Recognition") {
                    SpeechRecognitionView()
                }
            }
            .navigationTitle("Dev")
        }
    }
}

#Preview {
    DevView()
}
