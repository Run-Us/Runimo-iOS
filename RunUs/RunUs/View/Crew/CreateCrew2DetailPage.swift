//
//  CreateCrew2DetailPage.swift
//  RunUs
//
//  Created by 가은 on 12/3/24.
//

import SwiftUI

struct CreateCrew2DetailPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.primaryBG
                    .ignoresSafeArea()
                ScrollView {

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
}

#Preview {
    CreateCrew2DetailPage()
}
