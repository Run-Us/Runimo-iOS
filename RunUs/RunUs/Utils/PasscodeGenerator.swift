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
    
    var body: some View {
        HStack {
            
            ForEach(Array(fillZeroForCode(passcode).enumerated()), id: \.offset) { index, code in
                createCodeBox(code: code, isValid: isValid)
            }
        }
    }
    @ViewBuilder
    func createCodeBox(code: Character, isValid: Bool) -> some View {
        ZStack {
            Image(isValid ? "passcode_box" : "passcode_box.red")
            Text(String(!isValid || isInitialize ? "0" : code))
                .font(.title2_bold)
                .foregroundStyle(!isValid || isInitialize ? .gray300 : .primary400)
        }
    }
    
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

