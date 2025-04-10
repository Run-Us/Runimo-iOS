//
//  EggSheet.swift
//  Runimo
//
//  Created by 가은 on 4/9/25.
//

import SwiftUI

struct EggSheet: View {
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("다음 알을 부화시킬 차례예요")
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
                .padding(.vertical, 16)
            ScrollView {
                ForEach(sharedData.myEggs, id: \.item_id) { egg in
                    Button {
                        sharedData.showEggSheet = false
                        sharedData.egg_love = (sharedData.egg_love.egg - 1, sharedData.egg_love.love)
                        registerEggAPI(eggId: egg.item_id)
                    } label: {
                        eggCell(egg: egg)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.primaryFill)
    }
    
    @ViewBuilder
    private func eggCell(egg: EggItem) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: egg.img_url))
                .frame(width: 20, height: 20)
            Text(egg.name)
                .font(.body2_medium)
                .foregroundStyle(.secondaryGray)
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private func registerEggAPI(eggId: Int) {
        HomeService.shared.postEgg(egg_id: eggId) { 
            sharedData.updateHomeView = true
        }
    }
}

#Preview {
    EggSheet()
}
