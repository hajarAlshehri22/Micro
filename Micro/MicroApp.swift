//
//  MicroApp.swift
//  Micro
//
//  Created by Hajar Alshehri on 09/10/1445 AH.
//

import SwiftUI
import FirebaseCore

@main
struct MicroApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            
            UserInfo()
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
