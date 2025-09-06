//
//  Rank.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

enum Rank{
    case fossilSenior
    
    var name: String{
        switch self {
        case .fossilSenior:
            return "화석 선배"
        }
    }
    var tagline: String{
        switch self {
        case .fossilSenior:
            return "나 때는 말이야, 과방 소파가 기숙사였어."
        }
    }
    
    var explanation: String{
        switch self {
        case .fossilSenior:
            return "설명 문구"
        }
    }
}
