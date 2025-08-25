//
//  AudioPlayerService.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

import AVFoundation

enum AudioPlayerServiceError: Error, LocalizedError {
    case playerIsNotInitialized
}

final class AudioPlayerService {
    static let shared = AudioPlayerService()

    private init() {
        setupAudioSession()
    }

    private(set) var isPlaying: Bool = false
    private(set) var currentTime: TimeInterval = 0.0

    private var player: AVAudioPlayer? = nil

    func load(url: URL) throws {
        let player = try AVAudioPlayer(contentsOf: url)

        self.player = player
    }

    func load(audioData: Data) throws {
        let player = try AVAudioPlayer(data: audioData)

        self.player = player
    }

    func play() throws {
        guard let player else {
            throw AudioPlayerServiceError.playerIsNotInitialized
        }
        
        player.play()
        isPlaying = true
    }

    func pause() throws {
        guard let player else {
            throw AudioPlayerServiceError.playerIsNotInitialized
        }
        
        player.stop()
        isPlaying = false
    }

    func stop() throws {
        guard let player else {
            throw AudioPlayerServiceError.playerIsNotInitialized
        }
        
        player.stop()
        player.currentTime = 0.0
        isPlaying = false
    }
    
    func seek(to time: TimeInterval) throws {
        guard let player else {
            throw AudioPlayerServiceError.playerIsNotInitialized
        }
        
        player.currentTime = max(0.0, min(time, player.duration))
        self.currentTime = player.currentTime
    }

    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to set audio session")
        }
    }
}
