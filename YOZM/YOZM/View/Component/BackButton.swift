//
//  BackButton.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.backward")
                .font(.title)
                .bold()
                .foregroundStyle(.grayNormal)
        }
    }
}

#Preview {
    BackButton()
}
