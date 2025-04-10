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
    @Published var characterPopUpData: CharacterPopUpItem
    @Published var showCharacterPopUp: Bool = false
    @Published var isHatchable: Bool = false
    
    init() {
        characterPopUpData = CharacterPopUpItem(character: HatchEggResponse(name: "신비로운 알을 발견했어요", img_url: "home_egg_image", code: "", is_duplicated: false))
    }
}
