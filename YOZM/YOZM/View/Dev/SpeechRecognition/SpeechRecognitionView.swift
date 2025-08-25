//
//  SpeechRecognitionView.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

import SwiftUI

struct SpeechRecognitionView: View {
    private let speechRecognitionService = SpeechRecognitionService.shared
    
    var body: some View {
        VStack {
            resultText
            
            HStack {
                startButton
                stopButton
            }
        }
        .padding()
    }
    
    private var resultText: some View {
        Text(speechRecognitionService.result ?? "")
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var startButton: some View {
        Button("시작") {
            speechRecognitionService.startTranscribing()
        }
        .buttonStyle(.bordered)
    }
    
    private var stopButton: some View {
        Button("중지") {
            speechRecognitionService.stopTranscribing()
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    SpeechRecognitionView()
}
