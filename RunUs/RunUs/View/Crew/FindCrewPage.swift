//
//  FindCrewPage.swift
//  RunUs
//
//  Created by 가은 on 12/2/24.
//

import SwiftUI

struct FindCrewPage: View {
    @State private var showCreateCrewPage: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.primaryBG
                    .ignoresSafeArea()
                VStack {
                    
                }
                createCrewButton()
            }
            .navigationDestination(isPresented: $showCreateCrewPage) {
                CreateCrew1TagTypePage()
            }
        }
    }
    
    @ViewBuilder
    private func createCrewButton() -> some View {
        Button {
            showCreateCrewPage = true
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
