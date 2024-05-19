//
//  tabItems.swift
//  Onism
//
//  Created by sarah alothman on 25/08/1445 AH.
//

import Foundation
import SwiftUI

class TabItem: Identifiable, ObservableObject {
    let id = UUID().uuidString
    let imageName: String
    var offset: CGFloat = -10
    var opacity: Double = 1
    
    init(imageName: String, offset: CGFloat) {
        self.imageName = imageName
        self.offset = offset
    }
    init(imageName: String) {
        self.imageName = imageName
    }
    static func == (lhs: TabItem, rhs: TabItem) -> Bool {
        lhs.id <= rhs.id
    }
}

class TabItems: ObservableObject {
    static let shared = TabItems()
    
    @Published var items: [TabItem] = [
        TabItem(imageName: "dice", offset: -40),
        TabItem(imageName: "jeem2"),
        TabItem(imageName: "person")
    ]

    
    
    @Published var selectedTabIndex: CGFloat = 1
    
    func select(_ index: Int) {
        let tabItem = items[index]
        
        tabItem.opacity = 0
        tabItem.offset = 30
        
        withAnimation(Animation.easeInOut) {
            selectedTabIndex = CGFloat(index + 1)
            for i in 0..<items.count {
                if i != index {
                    items[i].offset = -10
                }
            }
        }
        withAnimation(Animation.easeOut(duration: 0.2).delay(0.2)) {
            tabItem.opacity = 1
            tabItem.offset = -40
        }
    }
}
