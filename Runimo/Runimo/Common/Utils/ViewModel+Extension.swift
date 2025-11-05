//
//  ViewModel+Extension.swift
//  Runimo
//
//  Created by 가은 on 11/5/25.
//

import Foundation

// MARK: - ViewModel용 Extension
extension ObservableObject {
    /// ViewModel에서 에러를 간단히 처리
    /// - Parameters:
    ///   - error: 발생한 에러
    ///   - function: 호출한 함수명 (자동)
    ///   - file: 파일명 (자동)
    ///   - line: 라인 번호 (자동)
    func handleError(
        _ error: Error,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        Logger.logAPIError(error, function: function, file: file, line: line)
    }
}
