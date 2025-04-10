//
//  Character.swift
//  Runimo
//
//  Created by 가은 on 3/26/25.
//

import Foundation

struct CharacterItem: Hashable {
    let name: String
    let imageName: String
    let disabled: Bool
}

struct RunimoIdResponse: Codable {
    let main_runimo_id: Int
}
