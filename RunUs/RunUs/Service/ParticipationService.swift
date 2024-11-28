//
//  ParticipationService.swift
//  RunUs
//
//  Created by byeoungjik on 10/1/24.
//

import Foundation
import KeychainSwift

class ParticipationService: ObservableObject {
    
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] as? String ?? "nil baseUrl")"
    let keychain = KeychainSwift()
    @Published var aggregateParticipants: [AggregateParticipants]? = []
    @Published var runningId: RunningId?
    
    func enterGroupRun(passCode: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "/runnings/\(passCode)/sessionId") else {
            completion(false)
            return
        }
        let jwtToken = keychain.get("accessToken") ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(BaseResponse<RunningId>.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.success {
                        print("enterGroupRun || Response success: \(decodedResponse.success)")
                        self.runningId = decodedResponse.payload
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
        
    }
    func getParticipantList(runningId: String, completion: @escaping (Bool, [AggregateParticipants]?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/runnings/\(runningId)/participants") else {
            completion(false, nil)
            return
        }
        let jwtToken = keychain.get("accessToken") ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(BaseResponse<[AggregateParticipants]>.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.success {
                        print("getParticipantList || Response success: \(decodedResponse.success)")
                        self.aggregateParticipants = decodedResponse.payload
                        completion(true, self.aggregateParticipants)
                    } else {
                        completion(false, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }.resume()
    }
}
