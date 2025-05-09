//
//  PostCardList.swift
//  RunUs
//
//  Created by 가은 on 11/4/24.
//

import SwiftUI

struct PostCardList: View {
    @EnvironmentObject var navigation: NavigationManager
    @State private var runningSessionList: [RunningRecord] = []
    private let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    @State private var showDateSheet: Bool = false
    @State private var page: Int = 0
    @State private var totalCount: Int = 0
    @State private var totalPage: Int = 1
    @State private var isLoading = false
    @State private var selectedDate: Date = Date()
    
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
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            getRunningRecordsAPI()
        }
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
                Text(DateManager.shared.getDateString(date: Date(), type: .monthly))
                    .font(.title4_semibold)
                Button {
                    showDateSheet = true
                } label: {
                    Image("arrow_down")
                }
                Spacer()
            }
            .foregroundStyle(.primaryGray)
            Text("\(nickname)님은 \(DateManager.shared.getMonth(date: Date()))월달에 총 \(totalCount)번을 달리셨어요.")
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
            if record.id == runningSessionList.last?.id && !isLoading && page < totalPage {
                getRunningRecordsAPI()
            }
        }
    }
    
    private func getRunningRecordsAPI() {
        isLoading = true
        RunningSessionService.shared.getMyRunningRecords(page: page, selectedDate: selectedDate) { result in
            DispatchQueue.main.async {
                totalPage = result.pagination.total_pages
                totalCount = result.pagination.total_items
                runningSessionList += result.items
                page += 1
                isLoading = false
            }
        }
    }
}

#Preview {
    PostCardList()
}
