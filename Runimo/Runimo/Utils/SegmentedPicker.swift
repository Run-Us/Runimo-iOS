//
//  SegmentedPicker.swift
//  RunUs
//
//  Created by 가은 on 10/14/24.
//

import SwiftUI

struct SegmentedPicker: View {
    @Binding var selectedTab: Int
    var type: [String] = []
    var width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ForEach(0..<type.count, id: \.self) { index in
                    Button {
                        selectedTab = index
                    } label: {
                        Text(type[index])
                            .frame(maxWidth: .infinity)
                            .font(.body1_medium)
                            .foregroundStyle(selectedTab == index ? .primaryGray : .gray400)
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 13, trailing: 0))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Picket 아래 이동하는 바 (애니메이션 포함)
            Rectangle()
                .fill(.primary400)
                .frame(width: width/CGFloat(type.count), height: 2)
                .offset(x: width / CGFloat(type.count) * CGFloat(selectedTab))
                .animation(.easeOut, value: selectedTab)
        }
    }
}

