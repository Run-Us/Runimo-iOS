//
//  LottieView.swift
//  Runimo
//
//  Created by 가은 on 7/2/25.
//

import Lottie
import SwiftUI

enum LottieSource {
    case asset(name: String) // 앱 내 리소스
    case remote(url: URL) // 서버에서 다운
}

struct LottieView: UIViewRepresentable {
    let source: LottieSource
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView()
        animationView.loopMode = loopMode
        
        switch source {
        case .asset(let name):
            animationView.animation = LottieAnimation.named(name)
            animationView.play()
        case .remote(let url):
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else { return }
                
                do {
                    let animation = try LottieAnimation.from(data: data)
                    DispatchQueue.main.async {
                        animationView.animation = animation
                        animationView.play()
                    }
                } catch {
                    print("❌ Lottie 파싱 실패: \(error)")
                }
            }
        }
        
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
