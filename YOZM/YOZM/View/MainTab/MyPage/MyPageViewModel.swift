//
//  MyPageViewModel.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

import Foundation

@Observable
final class MyPageViewModel {
    
    private(set) var user: User
    
    init(user: User = .sample) {
        self.user = user
    }
    
}
