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
    let idToken = UserDefaults.standard.integer(forKey: "idToken")
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
    
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


