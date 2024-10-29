//
//  RunTab.swift
//  RunUs
//
//  Created by 가은 on 10/14/24.
//

import SwiftUI

struct RunTab: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var mapVM: MapViewModel = .init()
    @ObservedObject var runningSession: RunningSessionService = .init()
    @State private var selectedRunning = 0
    @State private var showRunningPage: Bool = false
    let typeOfRunning = ["혼자 달리기", "그룹 달리기"]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // toolbar와 구분
                    Divider()
                    
                    // Segmented Picker
                    SegmentedPicker(selectedTab: $selectedRunning, type: typeOfRunning, width: geometry.size.width)
                    
                    switch(selectedRunning) {
                    case 0: runAlone()
                    case 1: StartGroupRunPage(runningSession: runningSession, mapVM: mapVM)
                    default: EmptyView()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 8, height: 14)
                                Text("달리기")
                                    .font(.body1_medium)
                            }
                            .foregroundStyle(.gray900)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    @ViewBuilder
    func runAlone() -> some View {
        ZStack(alignment: .bottom) {
            MapPage(mapVM: mapVM)
                .ignoresSafeArea()
            // 지도 위 흰색 그라데이션 효과
            LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Button {
                showRunningPage = true
            } label: {
                Image("run_start")
                    .shadow(radius: 2, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .offset(y: -15)
            .navigationDestination(isPresented: $showRunningPage) {
                RunningPage(runningType: .alone, mapVM: mapVM)
            }
            
        }
    }
}

#Preview {
    RunTab()
}
