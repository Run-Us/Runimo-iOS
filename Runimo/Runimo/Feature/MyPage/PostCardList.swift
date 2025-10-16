//
//  PostCardList.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import SwiftUI

struct PostCardList: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var runVM: RunningViewModel
    private let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    @State private var showDateSheet: Bool = false

    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                header()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)

                ScrollView {
                    LazyVStack {
                        ForEach(runVM.runningList, id: \.id) { record in
                            postCardView(record)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            // 데이터 초기화 후 첫 페이지 로드
            runVM.resetRunningRecords()
            runVM.getMyRunningRecords(page: 0, selectedDate: sharedData.selectedDateForSessionTab)
        }
        .onChange(of: sharedData.selectedDateForSessionTab, { _, _ in
            // 기간 변경 후 데이터 초기화 및 재로드
            runVM.resetRunningRecords()
            runVM.getMyRunningRecords(page: 0, selectedDate: sharedData.selectedDateForSessionTab)
        })
        .sheet(isPresented: $showDateSheet) {
            DateSheet(recordType: .monthly)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.35), .large])
        }
    }

    @ViewBuilder
    private func header() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(DateManager.shared.getDateString(date: sharedData.selectedDateForSessionTab, type: .monthly))
                    .font(.title4_semibold)
                Button {
                    showDateSheet = true
                } label: {
                    Image("arrow_down")
                }
                Spacer()
            }
            .foregroundStyle(.primaryGray)
            Text("\(nickname)님은 \(DateManager.shared.getMonth(date: sharedData.selectedDateForSessionTab))월달에 총 \(runVM.totalRunningCount)번을 달리셨어요.")
                .font(.body2_medium)
                .foregroundStyle(.quaternaryGray)
        }
    }
    
    @ViewBuilder
    private func postCardView(_ record: RunningRecord) -> some View {
        NavigationLink(destination: RunningPostPage(recordId: record.id ?? "")) {
            PostCard(runningRecord: record)
                .padding(.bottom, 14)
        }
        .onAppear {
            // 마지막 항목에 도달하면 다음 페이지 로드 (무한 스크롤)
            if record.id == runVM.runningList.last?.id {
                let nextPage = runVM.currentPage + 1
                runVM.getMyRunningRecords(page: nextPage, selectedDate: sharedData.selectedDateForSessionTab)
            }
        }
    }
}

#Preview {
    PostCardList()
}
