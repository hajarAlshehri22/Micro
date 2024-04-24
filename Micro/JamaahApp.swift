//
//  MicroApp.swift
//  Micro
//
//  Created by Hajar Alshehri on 09/10/1445 AH.
//

import SwiftUI


@main
struct JamaahApp: App {
    @StateObject  var vm = ViewModel()
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            CalendarPage()
                .environmentObject(vm)
        }
       // .modelContainer(sharedModelContainer)
    }
}
