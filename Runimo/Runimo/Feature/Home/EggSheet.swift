//
//  EggSheet.swift
//  Runimo
//
//  Created by 가은 on 4/9/25.
//

import SwiftUI
import Kingfisher

struct EggSheet: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("다음 알을 부화시킬 차례예요")
                .font(.title5_bold)
                .foregroundStyle(.primaryGray)
                .padding(.vertical, 16)
            ScrollView {
                ForEach(homeVM.myEggs, id: \.item_id) { egg in
                    Button {
                        sharedData.showEggSheet = false
                        homeVM.registerEgg(eggId: egg.item_id)
                    } label: {
                        eggCell(egg: egg)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(.primaryFill)
        .onAppear {
            homeVM.getMyEggs()
        }
    }
    
    @ViewBuilder
    private func eggCell(egg: EggItem) -> some View {
        HStack(spacing: 12) {
            KFImage(URL(string: egg.img_url))
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
            Text(egg.name)
                .font(.body2_medium)
                .foregroundStyle(.secondaryGray)
            Text("\(egg.amount)개")
                .font(.body2_medium)
                .foregroundStyle(.secondaryGray)
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    EggSheet()
}
