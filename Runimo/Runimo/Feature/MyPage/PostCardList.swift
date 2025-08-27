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
    @State private var runningSessionList: [RunningRecord] = []
    private let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    @State private var showDateSheet: Bool = false
    @State private var page: Int = 0
    @State private var totalPage: Int = 1
    @State private var isLoading = false
    
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
                        ForEach(runningSessionList, id: \.id) { record in
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
            runningSessionList = []
            page = 0
            getRunningRecordsAPI()
        }
        .onChange(of: sharedData.selectedDateForSessionTab, { _, _ in
            // 기간 변경 후 데이터 초기화
            runningSessionList = []
            page = 0
            getRunningRecordsAPI()
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
            Text("\(nickname)님은 \(DateManager.shared.getMonth(date: sharedData.selectedDateForSessionTab))월달에 총 \(sharedData.totalRunningCount)번을 달리셨어요.")
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
            if record.id == runningSessionList.last?.id && !isLoading && page+1 < totalPage {
                page += 1
                getRunningRecordsAPI()
            }
        }
    }
    
    private func getRunningRecordsAPI() {
        isLoading = true
        RunningSessionService.shared.getMyRunningRecords(page: page, selectedDate: sharedData.selectedDateForSessionTab) { result in
            DispatchQueue.main.async {
                totalPage = result.pagination.total_pages
                sharedData.totalRunningCount = result.pagination.total_items
                runningSessionList += result.items
                isLoading = false
            }
        }
    }
}

#Preview {
    PostCardList()
}
