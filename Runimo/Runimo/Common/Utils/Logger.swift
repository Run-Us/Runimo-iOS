//
//  Logger.swift
//  Runimo
//
//  Created by 가은 on 11/5/25.
//

import Foundation
import Alamofire

class Logger {
    // MARK: 일반 로그
    /// 기본 로그 메서드
    /// - Parameters:
    ///   - message: 로그 메세지
    ///   - function: 호출한 함수명 (자동으로 채워짐)
    ///   - file: 파일명 (자동으로 채워짐)
    ///   - line: 라인 번호 (자동으로 채워짐)
    static func log(
        _ message: String,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print("[\(fileName):\(line)] \(function)")
        print("   └─ \(message)")
        #endif
    }
    
    // MARK: API 에러 로그
    /// API 에러 전용 로그 (상세 정보 포함)
    /// - Parameters:
    ///   - error: 발생한 에러
    ///   - api: API 엔드포인트 경로 (옵션)
    ///   - function: 호출한 함수명 (자동으로 채워짐)
    ///   - file: 파일명 (자동으로 채워짐)
    ///   - line: 라인 번호 (자동으로 채워짐)
    static func logAPIError(
        _ error: Error,
        path: String? = nil,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print("[❌\(fileName):\(line)] \(function)")
        
        if let path = path {
            print("   API: \(path)")
        }
        
        if let afError = error as? AFError {
            // HTTP 상태 코드
            if let statusCode = afError.responseCode {
                print("   Status Code: \(statusCode)")
            }
            
            if let error = afError.underlyingError {
                print("   Underlying: \(error.localizedDescription)")
            }
        }
        
        #endif
    }
}
