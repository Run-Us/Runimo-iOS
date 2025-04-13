//
//  CharacterPopUp.swift
//  Runimo
//
//  Created by 가은 on 3/26/25.
//

import SwiftUI
import Kingfisher

struct CharacterPopUp: ViewModifier {
    @Binding var isPresented: Bool
    let index: Int
    var character: CharacterPopUpItem
    var isHatching: Bool = false
    var isDuplicated: Bool = false
    
    init(isPresented: Binding<Bool>, character: CharacterPopUpItem, index: Int, isHatching: Bool) {
        _isPresented = isPresented
        self.index = index
        self.character = character
        self.isHatching = isHatching
        self.isDuplicated = character.character.is_duplicated
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.quaternaryGray.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Text(isHatching ? isDuplicated ? "익숙한 친구를 만났어요.." : "새로운 동물이 태어났어요!" : character.character.name)
                        .font(.title4_semibold)
                        .foregroundStyle(.primaryGray)
                        .padding(.bottom, -8)
                    Text(isHatching ? character.character.name : "[간략한 설명 - 특성이나 재미있는 정보]")
                    if character.character.code == "" {
                        Image(character.character.img_url)
                            .resizable()
                            .frame(width: 320, height: 320)
                    } else {
                        KFImage(URL(string: character.character.img_url))
                            .placeholder { ProgressView() }
                            .resizable()
                            .frame(width: 320, height: 320)
                    }
                    
                    Text("러닝: [러닝 횟수], 달린 거리: [달린 거리]")
                        .padding(.bottom, 8)
                    
                    // 알 부화 했을 때
                    if isHatching {
                        VStack(spacing: 8) {
                            // 첫 등장 러니모일때만 ok button
                            if !isDuplicated {
                                okButton()
                            }
                            cancelButton()
                        }
                    } else {
                        // 캐릭터 선택으로 띄웠을 때
                        if index > 0 {
                            cancelButton()
                        } else {
                            okButton()
                        }
                    }
                }
                .font(.body2_medium)
                .foregroundStyle(.tertiaryGray)
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16))
                .background(.primaryBG)
                .cornerRadius(12)
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    private func cancelButton() -> some View {
        Button {
            isPresented = false
        } label: {
            Text("닫기")
                .font(.body1_bold)
                .foregroundStyle(.primaryGray)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.secondaryFill, lineWidth: 1)
                )
        }
    }
    
    @ViewBuilder
    private func okButton() -> some View {
        Button {
            isPresented = false
            if isHatching {
                setMainRunimoAPI()
            }
        } label: {
            Text(isHatching ? "대표 캐릭터로 설정하기" : "확인했어요")
                .font(.body1_bold)
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.primary400)
                .cornerRadius(8)
        }
    }
    
    private func setMainRunimoAPI() {
        // 대표 러니모 설정
        HomeService.shared.setMainRunimo(runimoId: character.character.id)
    }
}

extension View {
    func popupCharacter(isPresented: Binding<Bool>, character: CharacterPopUpItem, characterIndex: Int, isHatching: Bool) -> some View {
        self.modifier(CharacterPopUp(isPresented: isPresented, character: character, index: characterIndex, isHatching: isHatching))
    }
}
