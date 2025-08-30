//
//  StudyBackground.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct StudyBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.primaryNormal,
                Color.secondaryNormal,
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    StudyBackground()
}
