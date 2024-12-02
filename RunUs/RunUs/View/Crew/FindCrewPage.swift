//
//  FindCrewPage.swift
//  RunUs
//
//  Created by 가은 on 12/2/24.
//

import SwiftUI

struct FindCrewPage: View {
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.primaryBG
                .ignoresSafeArea()
            VStack {
                
            }
            createCrewButton()
        }
    }
    
    @ViewBuilder
    private func createCrewButton() -> some View {
        Button {
            
        } label: {
            Image("plus_floating_button")
                .resizable()
                .frame(width: 80, height: 80)
        }
        .padding(24)
    }
}

#Preview {
    FindCrewPage()
}
