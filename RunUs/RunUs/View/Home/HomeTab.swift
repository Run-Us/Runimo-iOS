//
//  HomePage.swift
//  RunUs
//
//  Created by byeoungjik on 9/9/24.
//

import SwiftUI

struct HomeTab: View {
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.primaryBG
                VStack(spacing: 24) {
                    userProfile()
                    RecordCard()
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
}

#Preview {
    HomeTab()
}
