//
//  Spacing.swift
//  YOZM
//
//  Created by Claude on 9/4/25.
//

import Foundation

enum Spacing {
    
    /// 초미세 간격 - 보통 요소 간 경계 구분이 필요한 경우 (ex. 텍스트 줄 간격, 아이콘과 텍스트 사이)
    static let xxxs: CGFloat = 2
    
    /// 매우 작음 - 마이크로 인터랙션 요소 간 (ex. 아이콘과 라벨 간)
    static let xxs: CGFloat = 4
    
    /// 작음 - 소규모 컴포넌트 간 (ex. 버튼 안 여백, 작은 padding)
    static let xs: CGFloat = 8
    
    /// 기본 - 가장 자주 쓰이는 간격 (ex. 컴포넌트 간 기본 여백)
    static let sm: CGFloat = 12
    
    /// 중간 - 섹션 분리 또는 카드 간 거리
    static let md: CGFloat = 16
    
    /// 넓음 - 전체 뷰 상하단 마진, 큰 덩어리 간 구분
    static let lg: CGFloat = 24
    
    /// 매우 넓음 - 주요 섹션, 모달과 본문 간 여백 등
    static let xl: CGFloat = 32
    
    /// 초대형 - 대형 타이틀과 콘텐츠 사이, 페이지 최상단 여백 등
    static let xxl: CGFloat = 40
    
    /// 최대 - 전체 뷰 레이아웃을 위한 마진 설정 시
    static let xxxl: CGFloat = 64
}
