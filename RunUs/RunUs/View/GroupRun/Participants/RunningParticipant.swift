//
//  RunningParticipant.swift
//  RunUs
//
//  Created by byeoungjik on 9/22/24.
//

import SwiftUI

struct RunningParticipant: View {
//    let grouprunParticipants: [Participant] = [
//        Participant(name: "김현재", distance: 6.1, pace: 5.2),
//        Participant(name: "문다훈", distance: 6.5, pace: 5.0),
//        Participant(name: "박지혜", distance: 6.1, pace: 5.1),
//        Participant(name: "유가은", distance: 6.1, pace: 5.3),
//        Participant(name: "이병직", distance: 6.1, pace: 5.4),
//        Participant(name: "조성훈", distance: 6.1, pace: 5.2)
//        ]
    
    var body: some View {
        VStack {
            List {
//                ForEach(grouprunParticipants, id: \.self.id) { participant in
//                    HStack(spacing: 20) {
//                        ParticipantProfile(participantName: participant.name)
//                            
//                        VStack {
//                            Text("\(participant.distance, specifier: "%.1f")")
//                            Text("거리")
//                        }
//                        
//                        VStack {
//                            Text("\(participant.pace, specifier: "%.1f")")
//                            Text("페이스")
//                        }
//                        .padding()
//                    }

//                }
            }
            .scrollContentBackground(.hidden)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RunningParticipant()
}
