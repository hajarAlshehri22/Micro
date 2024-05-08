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
            
            UserInfo()
                .environment(\.layoutDirection, .rightToLeft)
        }
        
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var db: Firestore! // Declare Firestore instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        db = Firestore.firestore() // Initialize Firestore
        return true
    }
}
