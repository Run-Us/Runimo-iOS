//
//  PasscodeView.swift
//  RunUs
//
//  Created by byeoungjik on 10/15/24.
//

import SwiftUI

struct PasscodeGenerator: View {
    @Binding var passcode: String
    @Binding var isValid: Bool
    @State var isInitialize: Bool = false
    let writeMode: Bool
    @State private var textFields: [String] = ["", "", "", ""]
    @FocusState private var focusedField: Int?
    
    var body: some View {
        HStack {
            ForEach(Array(passcode.enumerated()), id: \.offset) { index, code in
                createCodeBox(code: code, index: index ,isValid: isValid)
                    .onChange(of: textFields) { _ in
                        updatePasscode()
                    }
            }
        }
    }
    @ViewBuilder
    func createCodeBox(code: Character, index: Int, isValid: Bool) -> some View {
        ZStack {
            Image(isValid ? "passcode_box" : "passcode_box.red")
            if writeMode {
                TextField("0", text: $textFields[index])
                    .focused($focusedField, equals: index)
                    .multilineTextAlignment(.center)
                    .font(.title2_bold)
                    .foregroundStyle(!isValid || isInitialize ? .gray300 : .primary400)
                    .onChange(of: textFields[index]) { newValue in
                        handleInput(for: index, with: newValue)
                    }
                
            } else {
                Text(String(!isValid || isInitialize ? "0" : code))
                    .font(.title2_bold)
                    .foregroundStyle(!isValid || isInitialize ? .gray300 : .primary400)
            }
        }
    }
    
    // 작성한 코드 외 나머지 글자는 0 으로 채워 4자리로 맞추기
    func fillZeroForCode(_ code: String) -> String {
        let paddedCode = code.padding(toLength: 4, withPad: "0", startingAt: 0)
        return paddedCode
    }
    
    // 4자리 passcode를 업데이트
    private func updatePasscode() {
        let combined = textFields.joined()
        passcode = fillZeroForCode(combined)
    }
    
    private func handleInput(for index: Int, with newValue: String) {
        guard newValue.count <= 1 else {
            textFields[index] = String(newValue.prefix(1))
            return
        }
        if newValue.isEmpty {
            if index > 0 {
                focusedField = index - 1
            }
        } else {
            if index < 3 {
                focusedField = index + 1
            }
        }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

#Preview {
    PasscodeGenerator(passcode: .constant("0345"), isValid: .constant(true), isInitialize: false, writeMode: true)
}
