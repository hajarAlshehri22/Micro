//
//  theTabBar.swift
//  Onism
//
//  Created by sarah alothman on 25/08/1445 AH.
//

import Foundation
import SwiftUI

struct TabBar: View {
    let color = Color(red: 247/255, green: 242/255, blue: 249/255)
    let darkBackground = UIColor(red: 0.189, green: 0.187, blue: 0.256, alpha: 1.0)

    @ObservedObject var tabItems = TabItems.shared
    
    @State private var circleSize: CGFloat = 65 // Adjust the size of the circles here
    @State private var iconeSize: CGFloat = 25 // Adjust the size of the icons here
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                ZStack {
                    Bar(tab: tabItems.selectedTabIndex)
                        .foregroundColor(color)
                        .frame(width: UIScreen.main.bounds.width, height: 88)
                    HStack(spacing: (UIScreen.main.bounds.width - (CGFloat(tabItems.items.count + 1) * self.circleSize)) / (CGFloat(tabItems.items.count) + 1)) {
                        ForEach(0..<tabItems.items.count, id: \.self) { i in
                            ZStack {
                                Circle()
                                    .frame(width: self.circleSize, height: self.circleSize)
                                    .foregroundColor(color)
                                    .onTapGesture {
                                        self.tabItems.select(i)
                                        
                                        // Code to change tab screen can go here...
                                    }
                                Image(systemName: self.tabItems.items[i].imageName)
                                    .resizable()
                                    .foregroundColor(Color(self.darkBackground))
                                    .frame(width: self.iconeSize, height: self.iconeSize)
                                    .opacity(self.tabItems.items[i].opacity)
                            }
                            .offset(y: self.tabItems.items[i].offset)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar().environmentObject(TabItems.shared)
    }
}
