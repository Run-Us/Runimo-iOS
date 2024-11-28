//
//  RunningSessionService.swift
//  RunUs
//
//  Created by byeoungjik on 9/30/24.
//

import Foundation
import KeychainSwift
import CoreLocation
class RunningSessionService: ObservableObject {
    
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    let idToken = UserDefaults.standard.integer(forKey: "idToken")
    @Published var runningSessionInfo: RunningSessionInfo?

    func createRunningSession(currentLatitude: Double, currentLongitude: Double, completion: @escaping (Bool, RunningSessionInfo?) -> Void) {
        let url = URL(string: "\(baseUrl)/runnings?mode=normal")!
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let sessionData = RunningSession(
            constraints: RunningSessionConstraints(maxParticipantCount: 0, minPace: 0),
            description: RunningSessionDescription(title: "", desc: "", distance: "", runningTime: ""),
            startLocation: UserLocation(latitude: currentLatitude, longitude: currentLongitude)
        )
        
        var request = URLRequest(url: url)
        guard let accessToken = keychain.get("accessToken") else {
            print("Fail get accessToken")
            return
        }
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(sessionData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false, runningSessionInfo)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request failed: \(error?.localizedDescription ?? "No error info")")
                completion(false, self.runningSessionInfo)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(BaseResponse<RunningSessionInfo>.self, from: data)
                    DispatchQueue.main.async {
                        print("createRunningSession || Response success: \(response.success)|| runningKey : " + (response.payload!.runningId))
                        self.runningSessionInfo = response.payload
                        completion(true, self.runningSessionInfo)
                    }
                } catch {
                    print("Failed to decode JSON response: \(error)")
                    completion(false, self.runningSessionInfo)
                }
            } else {
                print("HTTP Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                completion(false, self.runningSessionInfo)
            }
        }.resume()
    }
    
}



