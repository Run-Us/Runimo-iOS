//
//  CharacterPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/10/24.
//

import SwiftUI

struct CharacterTab: View {
    @EnvironmentObject var sharedData: SharedData
    private let characterList: [CharacterItem] = [
        CharacterItem(name: "강아지", imageName: "character_dog", disabled: false),
        CharacterItem(name: "고양이", imageName: "character_cat", disabled: false),
        CharacterItem(name: "토끼", imageName: "character_rabbit", disabled: true),
        CharacterItem(name: "오리", imageName: "character_duck", disabled: true)
    ]
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]
    
    @Binding var selectedCharacterIndex: Int

    var body: some View {
        ScrollView {
            VStack {
                characterStage()
                    .padding(.top, 24)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            RunimoService.shared.getMyRunimo { result in
                sharedData.myRunimoData = result.runimos
            }
        }
    }

    @ViewBuilder
    private func characterStage() -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("🏡 마당")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Text("0km ~ 49km")
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
            }
            .padding(.vertical, 6)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(zip(characterList.indices, characterList)), id: \.0) { index, item in
                    Button {
                        if !item.disabled {
                            selectedCharacterIndex = index
                            sharedData.showCharacterPopUp = true
                        }
                    } label: {
                        characterCard(name: item.name, imageName: item.imageName, disabled: item.disabled, selected: selectedCharacterIndex == index)
                    }
                    .disabled(item.disabled)
                    
                }
            }
        }
    }

    @ViewBuilder
    private func characterCard(name: String, imageName: String, disabled: Bool, selected: Bool = false) -> some View {
        VStack(spacing: 16) {
            Image(imageName)
                .resizable()
                .frame(width: 120, height: 120)
            Text(name)
                .font(.body1_bold)
                .foregroundStyle(.tertiaryGray)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.primaryFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(selected ? .primary400 : .secondaryFill, lineWidth: selected ? 2 : 1)
                )
        )
        .opacity(disabled ? 0.3 : 1)
    }
}

#Preview {
    CharacterTab(selectedCharacterIndex: .constant(0))
}
