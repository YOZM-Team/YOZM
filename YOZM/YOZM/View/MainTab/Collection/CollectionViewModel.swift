//
//  CollectionViewModel.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

import Foundation

@Observable
final class CollectionViewModel {
    private(set) var cities: [String]
    private(set) var landmarks: [String]

    init() {
        // TODO: Change to fetch data
        self.cities = ["Seoul", "Busan"]
        self.landmarks = ["Gwanghwamun"]
    }
}
