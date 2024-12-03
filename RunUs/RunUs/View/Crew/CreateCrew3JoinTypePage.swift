//
//  CreateCrew3JoinTypePage.swift
//  RunUs
//
//  Created by 가은 on 12/3/24.
//

import SwiftUI

struct CreateCrew3JoinTypePage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack {
                    Divider()
                        .frame(height: 0.5)
                        .background(.secondaryFill)
                    Spacer()
                    CTAButton(text: "크루 만들기", disabled: false) {
                        // TODO: Create Crew API
                    }
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
    CreateCrew3JoinTypePage()
}
