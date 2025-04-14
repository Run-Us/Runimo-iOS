//
//  CharacterPage.swift
//  RunUs
//
//  Created by byeoungjik on 9/10/24.
//

import SwiftUI
import Kingfisher

struct CharacterTab: View {
    @EnvironmentObject var sharedData: SharedData
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(sharedData.allRunimoData, id: \.egg_type) { item in
                    characterStage(data: item)
                        .padding(.top, 24)
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            getMyRunimoAPI()
        }
        .onChange(of: sharedData.showCharacterPopUp) { _, newValue in
            // 팝업이 꺼질 때 API 다시 호출해서 뷰 다시 그리도록
            if newValue == false {
                getMyRunimoAPI()
            }
        }
    }

    @ViewBuilder
    private func characterStage(data: RunimoGroup) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(data.egg_type)")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Text("0km ~ 49km")
                    .font(.caption_regular)
                    .foregroundStyle(.quaternaryGray)
            }
            .padding(.vertical, 6)
            
            characterByType(runimos: data.runimo_types ?? [])
        }
    }
    
    @ViewBuilder
    private func characterByType(runimos: [RunimoInfo]) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            
            ForEach(runimos, id: \.code) { runimo in
                // 러니모 보유 여부, 선택 여부
                let itemDisabled = sharedData.myRunimoDataForDisplay[runimo.code] == nil
                let isSelectedIndex = sharedData.myRunimoDataForDisplay[runimo.code]?.is_main_runimo ?? false
                
                Button {
                    if !itemDisabled {
                        sharedData.setSelectedCharacter(code: runimo.code)
                        sharedData.showPopUp()
                    }
                } label: {
                    characterCard(name: runimo.name, imageName: runimo.img_url, disabled: itemDisabled, selected: isSelectedIndex)
                }
                .disabled(itemDisabled)
            }
        }
    }

    @ViewBuilder
    private func characterCard(name: String, imageName: String, disabled: Bool, selected: Bool = false) -> some View {
        VStack(spacing: 16) {
            KFImage(URL(string: imageName))
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
    
    // 보유 러니모 조회 API 
    private func getMyRunimoAPI() {
        RunimoService.shared.getMyRunimo { result in
            sharedData.myRunimoData = result.runimos
            sharedData.transformMyRunimo()
        }
    }
}

#Preview {
    CharacterTab()
}
