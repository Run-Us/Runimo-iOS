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
    let passCodeMode: Bool
    
    var body: some View {
        HStack {
            ForEach(Array(fillZeroForCode(passcode).enumerated()), id: \.offset) { index, code in
                createCodeBox(code: code, index: index ,isValid: isValid)
            }
        }
    }
    @ViewBuilder
    func createCodeBox(code: Character, index: Int, isValid: Bool) -> some View {
        ZStack {
            Image(isValid ? "passcode_box" : "passcode_box.red")
            if passCodeMode {
                TextField("0", text: $passcode)
                    .multilineTextAlignment(.center)
                    .font(.title2_bold)
                    .foregroundStyle(!isValid || isInitialize ? .gray300 : .primary400)
                
            } else {
                Text(String(!isValid || isInitialize ? "0" : code))
                    .font(.title2_bold)
                    .foregroundStyle(!isValid || isInitialize ? .gray300 : .primary400)
            }
        }
    }
    func bindingForCode(at index: Int) -> Binding<String> {
            Binding<String>(
                get: {
                    if self.passcode.count > index {
                        return String(self.passcode[self.passcode.index(self.passcode.startIndex, offsetBy: index)])
                    } else {
                        return "0"
                    }
                },
                set: { _ in
                    // 값 설정 부분을 비워두어 실제로 입력이 변하지 않도록 함
                }
            )
        }
    // 작성한 코드 외 나머지 글자는 0 으로 채워 4자리로 맞추기
    func fillZeroForCode(_ code: String) -> String {
        let paddedCode = code.padding(toLength: 4, withPad: "0", startingAt: 0)
        return paddedCode
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

#Preview {
    PasscodeGenerator(passcode: .constant("0345"), isValid: .constant(true), isInitialize: false, passCodeMode: true)
}
