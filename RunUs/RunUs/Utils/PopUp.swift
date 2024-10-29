//
//  PopUp.swift
//  RunUs
//
//  Created by 가은 on 10/21/24.
//

import Foundation
import SwiftUI

struct PopUp: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let subtitle: String
    let buttonText: String
    let buttonColor: Color
    let cancelAction: () -> Void
    let buttonAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                // 배경 어둡게
                Color.gray700.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // Text
                    VStack(spacing: 10) {
                        Text(title)
                            .font(.title4_semibold)
                        Text(subtitle)
                            .foregroundStyle(.gray600)
                            .font(.body2_medium)
                    }
                    
                    // 하단 버튼
                    HStack(spacing: 12) {
                        // 취소
                        Button {
                            isPresented = false
                            cancelAction()
                        } label: {
                            Text("취소")
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray300, lineWidth: 1)
                                )
                        }
                        
                        // 우측 버튼
                        Button {
                            isPresented = false
                            buttonAction()
                        } label: {
                            Text(buttonText)
                                .foregroundStyle(.white)
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .background(buttonColor)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .font(.body1_bold)
                }
                .foregroundStyle(.gray900)
                .padding()
                .background(.white)
                .cornerRadius(12)
                .padding(.horizontal, 15)
            }
        }
    }
}

extension View {
    public func popup(isPresented: Binding<Bool>, title: String, subtitle: String, buttonText: String, buttonColor: Color, cancelAction: @escaping () -> Void, buttonAction: @escaping () -> Void) -> some View {
        self.modifier(PopUp(isPresented: isPresented, title: title, subtitle: subtitle, buttonText: buttonText, buttonColor: buttonColor, cancelAction: cancelAction, buttonAction: buttonAction))
    }
}
