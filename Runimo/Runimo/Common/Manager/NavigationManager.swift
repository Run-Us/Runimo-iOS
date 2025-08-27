//
//  NavigationManager.swift
//  Runimo
//
//  Created by 가은 on 4/14/25.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func goToRootPage() {
        path.removeLast(path.count)
    }

}
