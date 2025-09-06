//
//  MyPageView.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        
        VStack(spacing: 16) {
            
            navigationBar
            
            VStack{
                
                Image(.characterRank1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 157, height: 157)
                
                
            }
        }
        .padding(24)
    }
    
    private var navigationBar: some View {
        HStack(spacing: 12) {
            Text("My Page")
                .font(.title2)
                .bold()
            
            Spacer()
            
            Image(systemName: "bell")
                .font(.title)
                .bold()
            
            Image(systemName: "gearshape")
                .font(.title)
                .bold()
            
        }
    }
}

#Preview {
    MyPageView()
}
