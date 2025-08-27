//
//  LottieView.swift
//  Runimo
//
//  Created by 가은 on 7/2/25.
//

import Lottie
import SwiftUI

enum LottieSource {
    case asset(name: String, mode: LottieLoopMode = .loop) // 앱 내 리소스
    case remote(url: URL, mode: LottieLoopMode = .loop) // 서버에서 다운
}

struct LottieView: UIViewRepresentable {
    let source: LottieSource
    let reloadID: UUID

    func makeUIView(context: Context) -> LottieWrapperView {
        return LottieWrapperView()
    }

    func updateUIView(_ wrapper: LottieWrapperView, context: Context) {
        wrapper.play(source: source)
    }
}

final class LottieWrapperView: UIView {
    private let animationView = LottieAnimationView()
    private var isPlaying = false
    private var isCurrentPlayOnce = false
    private var pendingSource: LottieSource?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func play(source: LottieSource) {
        let loopMode: LottieLoopMode = {
            switch source {
            case .asset(_, let mode), .remote(_, let mode): return mode
            }
        }()

        // 실제 애니메이션 상태를 기준으로 대기 판단 (애정주기를 누르고 있을 때, 알 빛남 loop 로띠 대기)
        if animationView.isAnimationPlaying && isCurrentPlayOnce && loopMode == .loop {
            pendingSource = source
            return
        }

        isPlaying = true
        isCurrentPlayOnce = loopMode == .playOnce

        switch source {
        case .asset(let name, let mode):
            animationView.loopMode = mode
            animationView.animation = LottieAnimation.named(name)
            animationView.play { [weak self] _ in
                self?.handleAnimationFinished()
            }

        case .remote(let url, let mode):
            animationView.loopMode = mode
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self,
                      let data = data,
                      let animation = try? LottieAnimation.from(data: data) else { return }

                DispatchQueue.main.async {
                    self.animationView.animation = animation
                    self.animationView.play { [weak self] _ in
                        self?.handleAnimationFinished()
                    }
                }
            }.resume()
        }
    }

    private func handleAnimationFinished() {
        isPlaying = false
        isCurrentPlayOnce = false

        // 대기 중 애니메이션 1개만 실행
        if let next = pendingSource {
            pendingSource = nil
            play(source: next)
        }
    }
}
