//
//  CharacterPopUp.swift
//  Runimo
//
//  Created by 가은 on 3/26/25.
//

import SwiftUI

struct CharacterPopUp: ViewModifier {
    private let characterList: [CharacterItem] = [
        CharacterItem(name: "강아지", imageName: "character_dog", disabled: false),
        CharacterItem(name: "고양이", imageName: "character_cat", disabled: false),
        CharacterItem(name: "토끼", imageName: "character_rabbit", disabled: true),
        CharacterItem(name: "오리", imageName: "character_duck", disabled: true)
    ]
    
    @Binding var isPresented: Bool
    let index: Int
    var character: CharacterItem
    
    init(isPresented: Binding<Bool>, index: Int) {
        _isPresented = isPresented
        self.index = index
        character = characterList[index]
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.quaternaryGray.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Text(character.name)
                        .font(.title4_semibold)
                        .foregroundStyle(.primaryGray)
                        .padding(.bottom, -8)
                    Text("[간략한 설명 - 특성이나 재미있는 정보]")
                    Image(character.imageName)
                        .resizable()
                        .frame(width: 320, height: 320)
                    Text("러닝: [러닝 횟수], 달린 거리: [달린 거리]")
                        .padding(.bottom, 8)
                    actionButton()
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
    private func actionButton() -> some View {
        Button {
            isPresented = false
        } label: {
            Text("취소")
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
}

extension View {
    func popupCharacter(isPresented: Binding<Bool>, characterIndex: Int) -> some View {
        self.modifier(CharacterPopUp(isPresented: isPresented, index: characterIndex))
    }
}
