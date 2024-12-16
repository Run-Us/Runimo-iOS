//
//  SessionDetailPage.swift
//  RunUs
//
//  Created by 가은 on 12/6/24.
//

import SwiftUI

struct SessionDetailPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.primaryBG.ignoresSafeArea()
                ScrollView {
                    
                }
                CTAButton(text: "세션 참가하기", disabled: false) {
                    // TODO: Add action
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
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image("vertical_dots")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.primaryGray)
                    }
                }
            }
        }
    }
}

#Preview {
    SessionDetailPage()
}
