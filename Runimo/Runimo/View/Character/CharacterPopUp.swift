//
//  CharacterPopUp.swift
//  Runimo
//
//  Created by 가은 on 3/26/25.
//

import SwiftUI
import Kingfisher

struct CharacterPopUp: ViewModifier {
    @EnvironmentObject var sharedData: SharedData
    @Binding var isPresented: Bool
    var character: CharacterPopUpItem
    var isHatching: Bool = false
    
    init(isPresented: Binding<Bool>, character: CharacterPopUpItem, isHatching: Bool) {
        _isPresented = isPresented
        self.character = character
        self.isHatching = isHatching
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.quaternaryGray.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Text(character.title)
                        .font(.title4_semibold)
                        .foregroundStyle(.primaryGray)
                        .padding(.bottom, -8)
                    Text(character.subtitle)
                    
                    KFImage(URL(string: character.imageURL))
                        .placeholder { ProgressView() }
                        .resizable()
                        .frame(width: 320, height: 320)
                    
                    Text(character.description)
                        .padding(.bottom, 8)
                    
                    // 알 부화 했을 때
                    if isHatching {
                        VStack(spacing: 8) {
                            // 첫 등장 러니모일때만 ok button
                            if !(sharedData.currentHatchedEgg?.is_duplicated ?? false) {
                                okButton()
                            }
                            cancelButton()
                        }
                    } else {
                        // 캐릭터 선택으로 띄웠을 때
                        cancelButton()
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
            sharedData.isHatchable = false
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
        if let data = sharedData.currentHatchedEgg {
            HomeService.shared.setMainRunimo(runimoId: data.id)
        }
    }
    
}

extension View {
    func popupCharacter(isPresented: Binding<Bool>, character: CharacterPopUpItem, isHatching: Bool) -> some View {
        self.modifier(CharacterPopUp(isPresented: isPresented, character: character, isHatching: isHatching))
    }
}
