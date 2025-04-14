//
//  SharedData.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Foundation

class SharedData: ObservableObject {
    @Published var currentMainTab: Tab = .home
    @Published var egg_love: (egg: Int, love: Int) = (0, 0)
    @Published var showEggSheet: Bool = false
    @Published var myEggs: [EggItem] = []
    @Published var characterPopUpData: CharacterPopUpItem
    @Published var showCharacterPopUp: Bool = false
    @Published var isHatchable: Bool = false
    @Published var updateHomeView: Bool = false
    
    // MARK: - 캐릭터 탭
    @Published var allRunimoData: [RunimoGroup] = []
    @Published var myRunimoData: [UserInfoWithRunimo] = []
    @Published var myRunimoDataForDisplay: Dictionary<String, UserInfoWithRunimo> = [:]
    
    init() {
        characterPopUpData = CharacterPopUpItem(character: HatchEggResponse(id: -1, name: "신비로운 알을 발견했어요", img_url: "home_egg_image", code: "", is_duplicated: false))
    }
    
    // 내가 보유한 러니모 데이터 -> [키(code): 값(러니모)] 형태로 변경
    func transformMyRunimo() {
        if myRunimoData.isEmpty { return }
        
        for runimo in myRunimoData {
            myRunimoDataForDisplay[runimo.code] = runimo
        }
    }
}
