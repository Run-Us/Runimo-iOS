//
//  CreateCrew2DetailPage.swift
//  RunUs
//
//  Created by 가은 on 12/3/24.
//

import SwiftUI

struct CreateCrew2DetailPage: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedProfile: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.primaryBG
                    .ignoresSafeArea()
                ScrollView {
                    Divider()
                        .frame(height: 0.5)
                        .background(.secondaryFill)
                    VStack(spacing: 32) {
                        VStack(spacing: 5) {
                            Text("크루를 만들어볼까요?")
                                .font(.title5_bold)
                                .foregroundStyle(.primaryGray)
                            Text("크루의 프로필을 등록해주세요")
                                .font(.body2_medium)
                                .foregroundStyle(.quaternaryGray)
                        }
                        .padding(.top, 24)
                        
                        profileImage()
                    }
                }
                CTAButton(text: "다음", disabled: .constant(true)) {
                    
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 8, height: 14)
                            .foregroundStyle(.primaryGray)
                    }
                    .frame(width: 14)
                }
            }
        }
    }
    
    @ViewBuilder
    func profileImage() -> some View {
        Button {
        } label: {
            Image(uiImage: selectedProfile ?? UIImage(named: "default_user_profile")!)   // TODO: change to crew default image
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 52))
        }
        .overlay(alignment: .bottomTrailing) {
            Image("plus_profile_button")
        }
        .padding(36)
        
    }
}

#Preview {
    CreateCrew2DetailPage()
}
