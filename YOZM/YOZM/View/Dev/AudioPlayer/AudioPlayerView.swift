//
//  AudioPlayerView.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

import SwiftUI

struct AudioPlayerView: View {
    private let audioPlayerService = AudioPlayerService.shared

    var body: some View {
        VStack {
            loadButton
            
            HStack {
                playButton
                pauseButton
                stopButton
            }
        }
    }

    private var loadButton: some View {
        Button("오디오 불러오기") {
            do {
                guard
                    let url = Bundle.main.url(
                        forResource: "SampleAudio",
                        withExtension: "mp3"
                    )
                else {
                    print("Failed to find audio file")
                    return
                }
                try audioPlayerService.load(url: url)
            } catch {
                print(error.localizedDescription)
            }
        }
        .buttonStyle(.bordered)
    }

    private var playButton: some View {
        Button("재생") {
            do {
                try audioPlayerService.play()
            } catch {
                print(error.localizedDescription)
            }
        }
        .buttonStyle(.bordered)
    }

    private var pauseButton: some View {
        Button("일시 정지") {
            do {
                try audioPlayerService.pause()
            } catch {
                print(error.localizedDescription)
            }
        }
        .buttonStyle(.bordered)
    }

    private var stopButton: some View {
        Button("정지") {
            do {
                try audioPlayerService.stop()
            } catch {
                print(error.localizedDescription)
            }
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    AudioPlayerView()
}
