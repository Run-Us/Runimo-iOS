//
//  SharedData.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Foundation

class SharedData: ObservableObject {
    @Published var egg_love: (egg: Int, love: Int) = (0, 0)
    @Published var showEggSheet: Bool = false
    @Published var myEggs: [EggItem] = []
    
    init() { }
}
