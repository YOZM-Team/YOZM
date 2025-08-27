//
//  PronunciationScoreService.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

final class PronunciationScoreService {
    static let shared = PronunciationScoreService()

    private init() {}

    func scorePronunciation(reference: String, hypothesis: String) -> Double {
        let referenceJamo: [Unicode.Scalar] = stringToJamoScalars(reference)
        let hypothesisJamo: [Unicode.Scalar] = stringToJamoScalars(hypothesis)

        var score: Double = 0
        for jamo in referenceJamo {
            if hypothesisJamo.contains(where: { $0 == jamo }) {
                score += 1
            }
        }
        score /= Double(referenceJamo.count)

        return score
    }

    private func stringToJamoScalars(_ original: String) -> [Unicode.Scalar] {
        return original
            .decomposedStringWithCanonicalMapping
            .unicodeScalars
            .filter {
                !$0.properties.isWhitespace && !$0.properties.isJoinControl
            }
    }
}
