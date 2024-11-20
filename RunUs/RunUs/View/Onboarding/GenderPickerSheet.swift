//
//  GenderPickerSheet.swift
//  RunUs
//
//  Created by byeoungjik on 10/14/24.
//

import SwiftUI

enum GenderType: String {
    case male = "MALE"
    case female = "FEMALE"
    case other = "OTHER"
    case none = "NONE"
}

struct GenderPickerSheet: View {
    @Binding var gender: String
    @Binding var showGenderPicker: Bool
    @Environment(\.dismiss) var dismiss
    @Binding var genderType: GenderType
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 32) {
                Text("성별 선택")
                    .font(.title5_bold)
                    .foregroundColor(.gray900)
                selectGenderButton(gender: "남성", .male)
                
                selectGenderButton(gender: "여성", .female)
                
                selectGenderButton(gender: "기타", .other)
                
            }
            .padding()
        }
        .onTapGesture {
            dismiss()
        }
        .onDisappear(perform: {
            showGenderPicker = false
            dismiss()
        })
    }
    
    @ViewBuilder
    func selectGenderButton(gender: String, _ genderType: GenderType) -> some View {
        Button(action: {
            self.gender = gender
            self.showGenderPicker = false
            self.genderType = genderType
            dismiss()
        }, label: {
            Text(gender)
                .font(.body2_medium)
                .foregroundColor(.gray700)
        })
    }
}

#Preview {
    GenderPickerSheet(gender: .constant(""), showGenderPicker: .constant(false), genderType: .constant(.none))
}
