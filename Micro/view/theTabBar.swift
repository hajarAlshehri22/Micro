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
    @State private var iconSize: CGFloat = 25 // Adjust the size of the icons here
    @State private var selectedView: AnyView = AnyView(Entertainment())

    @EnvironmentObject var vm: ViewModel
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                selectedView // This displays the selected view
                    .transition(.slide) // Add a transition if desired
                Spacer()
                if vm.shouldShowTabView{
                    ZStack {
                        Bar(tab: CGFloat(tabItems.selectedTabIndex))
                            .foregroundColor(color)
                            .frame(width: UIScreen.main.bounds.width, height: 88)
                        HStack(spacing: (UIScreen.main.bounds.width - (CGFloat(tabItems.items.count + 1) * self.circleSize)) / (CGFloat(tabItems.items.count) + 1)) {
                            ForEach(Array(tabItems.items.enumerated()), id: \.element.id) { index, item in
                                ZStack {
                                    Circle()
                                        .frame(width: self.circleSize, height: self.circleSize)
                                        .foregroundColor(color)
                                        .onTapGesture {
                                            self.tabItems.select(index)
                                            self.updateView(for: index) // Update the view based on the selected tab
                                        }
                                    // Check if the imageName matches custom assets to use a different initializer
                                    if item.imageName == "jeem2" {
                                        Image(item.imageName)
                                            .resizable()
                                            .foregroundColor(Color(self.darkBackground))
                                            .frame(width: self.iconSize, height: self.iconSize)
                                            .opacity(item.opacity)
                                    } else {
                                        Image(systemName: item.imageName)
                                            .resizable()
                                            .foregroundColor(Color(self.darkBackground))
                                            .frame(width: self.iconSize, height: self.iconSize)
                                            .opacity(item.opacity)
                                    }
                                }
                                .offset(y: item.offset)
                            }
                        }
                    }//tab bar
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    // Function to update the view based on the selected tab index
    private func updateView(for index: Int) {
        switch index {
        case 0:
            selectedView = AnyView(Entertainment())
        case 1:
            selectedView = AnyView(GroupsView())
        case 2:
            selectedView = AnyView(ContentView())
        default:
            selectedView = AnyView(GroupsView())
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar().environmentObject(TabItems.shared)
            .environmentObject(ViewModel())
    }
}


