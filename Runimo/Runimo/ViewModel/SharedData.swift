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
    @Published var characterPopUpData: CharacterPopUpItem?
    @Published var showCharacterPopUp: Bool = false
    @Published var isHatchable: Bool = false
    @Published var updateHomeView: Bool = false
    
    // MARK: - 캐릭터 탭
    @Published var allRunimoData: [RunimoGroup] = []
    @Published var allRunimoDataForDisplay: Dictionary<String, RunimoInfo> = [:]
    @Published var myRunimoData: [UserInfoWithRunimo] = []
    @Published var myRunimoDataForDisplay: Dictionary<String, UserInfoWithRunimo> = [:]
    
    // MARK: - 캐릭터 팝업
    @Published var currentHatchedEgg: HatchEggResponse?
    @Published var selectedRunimoCode: String = ""
    
    init() { }
    
    // MARK: - 사용하기 편한 형태로 변경
    // 고정 러니모 데이터 -> [키(code): 값(러니모)] 형태로 변경
    func transformAllRunimo() {
        for group in allRunimoData {
            for runimo in group.runimo_types ?? [] {
                allRunimoDataForDisplay[runimo.code] = runimo
            }
        }
    }
    
    // 내가 보유한 러니모 데이터 -> [키(code): 값(러니모)] 형태로 변경
    func transformMyRunimo() {
        if myRunimoData.isEmpty { return }
        
        for runimo in myRunimoData {
            myRunimoDataForDisplay[runimo.code] = runimo
        }
    }
    
    // 캐릭터 탭에서 터치한 캐릭터 코드
    func setSelectedCharacter(code: String) {
        selectedRunimoCode = code
    }
    
    // MARK: - 캐릭터 팝업 띄우기 위한 데이터
    // 고정 (이름, 이미지, 설명)
    func getFixedCharacterData() -> RunimoInfo? {
        if let data = allRunimoDataForDisplay[selectedRunimoCode] { return data }
        return nil
    }
    // 고정x: 달린 횟수, 거리
    func getSelectedCharacterData() -> UserInfoWithRunimo? {
        if let data = myRunimoDataForDisplay[selectedRunimoCode] { return data }
        return nil
    }
}
