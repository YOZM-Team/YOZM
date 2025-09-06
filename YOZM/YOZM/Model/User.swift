//
//  User.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

struct User{
    let nickname: String
    let rank: Rank
}

extension User{
    static var sample: User {
        User(
            nickname: "Nickname",
            rank: .fossilSenior
        )
    }
}
