//
//  MicroApp.swift
//  Micro
//
//  Created by Hajar Alshehri on 09/10/1445 AH.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct MicroApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            
            CreateView()
                .environment(\.layoutDirection, .rightToLeft)
        }
        
    }
    
}


