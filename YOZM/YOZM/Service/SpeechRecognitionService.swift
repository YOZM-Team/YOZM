//
//  SpeechRecognitionService.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

import AVFoundation
import Speech

@Observable
final class SpeechRecognitionService {
    static let shared = SpeechRecognitionService()

    private init() {}

    private(set) var result: String? = nil

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private var audioEngine: AVAudioEngine? = nil
    private var request: SFSpeechAudioBufferRecognitionRequest? = nil
    private var task: SFSpeechRecognitionTask? = nil

    func startTranscribing() {
        Task {
            guard let recognizer, recognizer.isAvailable else {
                return
            }
            
            guard await hasPermissions() else {
                return
            }
            
            do {
                try configureAudioSession()
            } catch {
                print(error.localizedDescription)
                return
            }
            
            do {
                try prepareEngine()
                guard let audioEngine = self.audioEngine, let request = self.request else { return }

                self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                    self?.recognitionHandler(
                        audioEngine: audioEngine,
                        result: result,
                        error: error
                    )
                }
            } catch {
                self.stopTranscribing()
            }
        }
    }

    func stopTranscribing() {
        task?.cancel()
        task = nil

        request?.endAudio()
        request = nil

        if let engine = audioEngine {
            engine.inputNode.removeTap(onBus: 0)
            engine.stop()
        }
        audioEngine = nil

        result = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func recognitionHandler(
        audioEngine: AVAudioEngine,
        result: SFSpeechRecognitionResult?,
        error: Error?
    ) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil

        if receivedFinalResult || receivedError {
            self.request?.endAudio()
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        if let result {
            self.result = result.bestTranscription.formattedString
        }

        if receivedError {
            stopTranscribing()
        }
    }

    private func prepareEngine() throws {
        let engine = AVAudioEngine()

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        if #available(iOS 13.0, *) {
            if let recognizer, recognizer.supportsOnDeviceRecognition {
                req.requiresOnDeviceRecognition = true
            }
        }

        let inputNode = engine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: format
        ) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
            req.append(buffer)
        }

        engine.prepare()
        try engine.start()

        self.audioEngine = engine
        self.request = req
    }

    private func hasPermissions() async -> Bool {
        let hasAuthorizationToRecognize =
            await SFSpeechRecognizer.hasAuthorizationToRecognize()
        let hasPermissionToRecord = await AVAudioSession.sharedInstance()
            .hasPermissionToRecord()

        return hasAuthorizationToRecognize && hasPermissionToRecord
    }

    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .record,
            mode: .measurement,
            options: .duckOthers
        )
        try session.setActive(true, options: .notifyOthersOnDeactivation)
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
