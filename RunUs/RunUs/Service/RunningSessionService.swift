//
//  RunningSessionService.swift
//  RunUs
//
//  Created by byeoungjik on 9/30/24.
//

import Alamofire
import Foundation
import KeychainSwift
import CoreLocation

class RunningSessionService: ObservableObject {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    @Published var latestSessionResponse: RunningSessionResponse?

    func createRunningSession(currentLatitude: Double, currentLongitude: Double, completion: @escaping (Bool, RunningSessionResponse?) -> Void) {
        let url = URL(string: "\(baseUrl)/runnings")!
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let sessionData = RunningSession(
            constraints: RunningSessionConstraints(maxParticipantCount: 0, minPace: 0),
            description: RunningSessionDescription(title: "", desc: "", distance: "", runningTime: ""),
            startLocation: UserLocation(latitude: currentLatitude, longitude: currentLongitude)
        )
        
        var request = URLRequest(url: url)
        if let accessToken = keychain.get("accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("Successfully get access token: \(accessToken)")
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(sessionData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false, latestSessionResponse)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request failed: \(error?.localizedDescription ?? "No error info")")
                completion(false, self.latestSessionResponse)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(RunningSessionResponse.self, from: data)
                    DispatchQueue.main.async {
                        print("createRunningSession || Response success: \(response.success)|| runningKey : " + response.payload.runningKey)
                        self.latestSessionResponse = response
                        completion(true, response)
                    }
                } catch {
                    print("Failed to decode JSON response: \(error)")
                    completion(false, self.latestSessionResponse)
                }
            } else {
                print("HTTP Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                completion(false, self.latestSessionResponse)
            }
        }.resume()
    }
    
    // 달리기 기록 저장
    func postAggregate(mode: String, runningId: String?, distance: Int, runningTime: Int, pace: Int) {
        let url = "\(baseUrl)/runnings/aggregates?mode=\(mode)"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        var parameters: [String: Any] = [
            "recordData": "",    // TODO: 압축한 문자열
            "runningDistanceInMeters": distance,
            "runningDurationInMilliSeconds": runningTime,
            "averagePaceInMilliSeconds": pace
        ]
        
        // 그룹 달리기만 runningId 추가
        if let runningId = runningId {
            parameters.updateValue(runningId, forKey: "runningId")
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<String>.self) { response in
                switch response.result {
                case .success(let response):
                    print("Aggregate Success: \(response)")
                case .failure(let error):
                    print("Aggregate Failed: \(error)")
                }
            }
    }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


