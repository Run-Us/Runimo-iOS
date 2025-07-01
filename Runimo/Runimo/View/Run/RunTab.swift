//
//  RunTab.swift
//  RunUs
//
//  Created by 가은 on 10/14/24.
//

import SwiftUI

struct RunTab: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var runVM: RunningViewModel
    @State private var selectedRunning = 0
    @State private var showRunningPage: Bool = false
    @State private var showPermissionPopUp: Bool = false
    let typeOfRunning = ["혼자 달리기", "그룹 달리기"]
    
    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // toolbar와 구분
                    Divider()
                    
                    // Segmented Picker
                    SegmentedPicker(selectedTab: $selectedRunning, type: typeOfRunning, width: geometry.size.width)
                    
                    switch(selectedRunning) {
                    case 0: runAlone()
                    case 1: StartGroupRunPage()
                    default: EmptyView()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            navigation.path.removeLast()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 8, height: 14)
                                Text("달리기")
                                    .font(.body1_medium)
                            }
                            .foregroundStyle(.primaryGray)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            mapVM.checkLocationPermission()
            mapVM.requestMotionAuthorization()
        }
        .popupCharacter(
            isPresented: $showPermissionPopUp,
            character: CharacterPopUpItem(id: -1, code: "permission", title: "위치 권한이 필요해요", subtitle: "러닝을 시작하려면 위치 접근 '항상 허용'이 필요해요.\n설정에서 변경해 주세요!", imageURL: "request_permission", description: ""),
            isHatching: false)
    }
    
    @ViewBuilder
    func runAlone() -> some View {
        ZStack(alignment: .bottom) {
            MapPage()
                .ignoresSafeArea()
            // 지도 위 흰색 그라데이션 효과
            LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Button {
                mapVM.checkLocationAlwaysAuthorization { isAuthorized in
                    if isAuthorized {
                        showRunningPage = true
                    } else {
                        showPermissionPopUp = true
                        print("위치 권한 항상 필요")
                    }
                }
                
            } label: {
                Image("run_start")
                    .shadow(radius: 2, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .offset(y: -15)
            .navigationDestination(isPresented: $showRunningPage) {
                RunningPage()
            }
            
        }
    }
}

#Preview {
    RunTab()
}
