//
//  StudyCardBackground.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct StudyCardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.yellowWhite)
            .shadow(
                color: Color(hex: "646464").opacity(0.25),
                radius: 0,
                x: 2,
                y: 6
            )
    }
}

#Preview {
    StudyCardBackground()
}
