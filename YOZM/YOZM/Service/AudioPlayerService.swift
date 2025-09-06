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

final class AudioPlayerService: NSObject {
    static let shared = AudioPlayerService()

    private override init() {
        super.init()
    }

    private(set) var isPlaying: Bool = false
    private(set) var currentTime: TimeInterval = 0.0

    private var player: AVAudioPlayer? = nil
    
    // 재생 완료를 위한 continuation
    private var playbackContinuation: CheckedContinuation<Void, Never>?

    func load(url: URL) throws {
        let player = try AVAudioPlayer(contentsOf: url)
        player.delegate = self
        self.player = player
    }

    func load(audioData: Data) throws {
        let player = try AVAudioPlayer(data: audioData)
        player.delegate = self
        self.player = player
    }

    func play() throws {
        guard let player else {
            throw AudioPlayerServiceError.playerIsNotInitialized
        }

        configureAudioSession()
        player.play()
        isPlaying = true
    }
    
    func playAndWait() async throws {
        guard let player else {
            throw AudioPlayerServiceError.playerIsNotInitialized
        }

        configureAudioSession()
        
        return await withCheckedContinuation { continuation in
            playbackContinuation = continuation
            player.play()
            isPlaying = true
        }
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
        
        playbackContinuation?.resume()
        playbackContinuation = nil
    }

    func seek(to time: TimeInterval) throws {
        guard let player else {
            throw AudioPlayerServiceError.playerIsNotInitialized
        }

        player.currentTime = max(0.0, min(time, player.duration))
        self.currentTime = player.currentTime
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to set audio session")
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        playbackContinuation?.resume()
        playbackContinuation = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        playbackContinuation?.resume()
        playbackContinuation = nil
        if let error = error {
            print("Audio decode error: \(error)")
        }
    }
}
