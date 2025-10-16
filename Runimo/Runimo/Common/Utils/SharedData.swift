//
//  SharedData.swift
//  Runimo
//
//  Created by 가은 on 4/2/25.
//

import Foundation

class SharedData: ObservableObject {
    @Published var isLogined: Bool?
    @Published var isSignUpComplete: Bool = false
    @Published var firstEgg: (id: Int, code: String) = (0, "")    // 첫 지급 알 코드
    @Published private(set) var currentMainTab: Tab = .home
    @Published var dateSheetSelectedIndex: Int = 0
    @Published var showCharacterPopUp: Bool = false
    
    // MARK: - 1. 홈 탭
    @Published var showEggSheet: Bool = false
    @Published var isHatchable: Bool = false
    @Published var updateHomeView: Bool = false
    
    // 튜토리얼
    @Published var showTutorial1Sheet: Bool = false
    @Published var showTutorial2Sheet: Bool = false

    // 알
    @Published var hatchEggFlag: Bool = false
    
    // MARK: - 2. 기록 리스트 탭
    @Published var selectedDateForSessionTab: Date = Date()
    
    // MARK: - 3. 캐릭터 탭
    @Published var allRunimoData: [RunimoGroup] = []
    @Published var allRunimoDataForDisplay: Dictionary<String, RunimoInfo> = [:]
    @Published var myRunimoData: [UserInfoWithRunimo] = []
    @Published var myRunimoDataForDisplay: Dictionary<String, UserInfoWithRunimo> = [:]
    @Published var totalUserRunningDistance: Int = 0
    @Published var updateCharacterView: Bool = false
    
    // MARK: - 4. 마이페이지
    // 설정
    @Published var withdrawReason: (reason: String, inputText: String) = ("", "")
    
    // MARK: - 캐릭터 팝업
    @Published var characterPopUpData: CharacterPopUpItem = CharacterPopUpItem(id: -1, code: "", title: "", subtitle: "", imageURL: "", description: "")
    @Published var currentHatchedEgg: HatchEggResponse?
    @Published var selectedRunimoCode: String = ""
    @Published var mainRunimoCode: String = ""
    
    init() { }
    
    func setTab(_ tab: Tab) {
        currentMainTab = tab
    }
    
    // 캐릭터 팝업 띄우기 
    func showPopUp() {
        settingData()
        showCharacterPopUp = true
    }
    
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
            
            // 메인 러니모 코드 저장
            if runimo.is_main_runimo {
                mainRunimoCode = runimo.code
            }
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

// MARK: - 캐릭터 팝업 데이터 세팅
extension SharedData {
    func settingData() {
        if isHatchable {
            setHatchData()
        } else {
            setCharacterData()
        }
    }
    
    // 부화 팝업 데이터
    private func setHatchData() {
        if let hatchData = currentHatchedEgg {
            characterPopUpData = CharacterPopUpItem(id: hatchData.id ?? 0, code: hatchData.code, title: hatchData.is_duplicated ? "익숙한 친구를 만났어요.." : "새로운 동물이 태어났어요!", subtitle: hatchData.name, imageURL: hatchData.img_url, description: "")
        }
    }
    
    // 캐릭터 선택 팝업
    private func setCharacterData() {
        if let notFixedData = getSelectedCharacterData(),
                  let fixedData = getFixedCharacterData()
        {
            characterPopUpData = CharacterPopUpItem(id: notFixedData.id, code: fixedData.code, title: fixedData.name, subtitle: fixedData.description, imageURL: fixedData.img_url, description: "러닝: \(notFixedData.total_run_count), 달린 거리: \(String(format: "%.2fkm", Double(notFixedData.total_distance_in_meters)/1000))")
        }
    }
    
}

// MARK: - Setting (설정)
extension SharedData {
    
}
