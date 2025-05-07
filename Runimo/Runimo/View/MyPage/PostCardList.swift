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
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.primaryBG
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Divider()
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 8) {
                    Button {
                        navigation.path.removeLast()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 14, height: 14)
                    }
                    Text("모든 활동")
                        .font(.body1_medium)
                }
                .foregroundStyle(.primaryGray)
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
            Text("\(nickname)님은 \(DateManager.shared.getMonth(date: Date()))월달에 총 \(runningSessionList.count)번을 달리셨어요.")
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
            if record.id == runningSessionList.last?.id && !isLoading {
                getRunningRecordsAPI()
            }
        }
    }
    
    private func getRunningRecordsAPI() {
        isLoading = true
        RunningSessionService.shared.getMyRunningRecords(page: page) { result in
            DispatchQueue.main.async {
                runningSessionList += result.record_list
                page += 1
                isLoading = false
            }
        }
    }
}

#Preview {
    PostCardList()
}
