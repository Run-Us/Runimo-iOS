//
//  HomePage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct HomeTab: View {
    @State private var sessionCardIndex: Int = 0
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.primaryBG
                VStack(spacing: 24) {
                    userProfile()
                    RecordCard()
                    scheduledRunning()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
        }
    }
    
    @ViewBuilder
    private func userProfile() -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 7) {
                Text("\(UserDefaults.standard.string(forKey: "nickname") ?? "")님")
                    .foregroundStyle(.primaryGray)
                    .font(.title5_bold)
                Text("Lv1 ∙ 12km")
                    .foregroundStyle(.quaternaryGray)
                    .font(.caption_semibold)
                ProgressBar(progress: .constant(0.7))
            }
            Image("default_user_profile")
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
    
    @ViewBuilder
    private func scheduledRunning() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("예정 러닝세션")
                    .font(.title5_bold)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Button {
                    
                } label: {
                    Text("더 보기")
                        .font(.caption_regular)
                        .foregroundStyle(.quaternaryGray)
                }
            }
            
            TabView(selection: $sessionCardIndex) {
                // TODO: 세션카드 (JIS-48)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // page dots
            HStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(index == sessionCardIndex ? .primary500 : .primary200)
                }
            }
        }
    }
}

#Preview {
    HomeTab()
}
