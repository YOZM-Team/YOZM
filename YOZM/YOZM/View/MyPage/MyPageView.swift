//
//  MyPageView.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

import SwiftUI

struct MyPageView: View {
    
    @State private var viewModel: MyPageViewModel

    init(viewModel: MyPageViewModel = MyPageViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ZStack {
            
            background
            
            VStack(spacing: 20) {//Spacing에 없는 padding
                
                navigationBar
                
                VStack(spacing: Spacing.xs){
                    
                    Image(.characterRank1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 157, height: 157)
                    
                    HStack(spacing: Spacing.xs){
                        Text(viewModel.user.nickname)
                            .font(.title2)
                            .bold()
                        
                        rankName
                    }
                }
                
                VStack(spacing: Spacing.md){
                    rankTagLine
                    rankExplanation
                }
                Spacer()
            }
            .padding(24)
        }
    }
    
    private var background: some View {
        StudyBackground()
    }
    
    private var rankName: some View {
        Text(viewModel.user.rank.name)
            .font(.body)
            .bold()
            .foregroundStyle(.white)
            .padding(.vertical, 6)//Spacing에 없는 padding
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                     .fill(Color(hex: "A5C3BE"))
            }

    }
    
    private var rankTagLine: some View {
        Text("\"\(viewModel.user.rank.tagline)\"")
            .font(.callout)
            .bold()
            .foregroundStyle(.blackNormal)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)//Spacing에 없는 padding
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blueNormal)
            }
    }
    
    
    private var rankExplanation: some View {
        Text(viewModel.user.rank.explanation)
            .font(.subheadline)
            .foregroundStyle(.blackNormal)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity)
            .padding(10)
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            }
    }
    
    private var navigationBar: some View {
        HStack(spacing: Spacing.sm) {
            Text("MyPage")
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
