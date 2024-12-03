//
//  CreateCrew1TagTypePage.swift
//  RunUs
//
//  Created by 가은 on 12/2/24.
//

import SwiftUI

struct CreateCrew1TagTypePage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBG
                VStack {
                    Divider()
                    VStack {
                        
                    }
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.primaryGray)
                    }
                }
            }
        }
    }
}

#Preview {
    CreateCrew1TagTypePage()
}
