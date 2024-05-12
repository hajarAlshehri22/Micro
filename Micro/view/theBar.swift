//
//  theBar.swift
//  Onism
//
//  Created by sarah alothman on 25/08/1445 AH.
//

import Foundation
import SwiftUI

// Define a custom shape for the tab bar
struct Bar: Shape {
    // The current selected tab index
    var tab: CGFloat
    
    // Animate changes to the shape
    var animatableData: Double {
        get { return Double(tab) }
        set { tab = CGFloat(newValue) }
    }
    
    // Define the path for the shape
    func path(in rect: CGRect) -> Path {
        // Initialize a new path
        var path = Path()
        
        // Calculate the width factor for the tabs
        let widthFactor = rect.maxX / (CGFloat(TabItems.shared.items.count) + 1)
        // Calculate the width factor times the selected tab index
        let widthFactorTimesCount = (rect.maxX / (CGFloat(TabItems.shared.items.count) + 1)) * tab
        
        // Move to the starting point of the path
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        // Add lines to create the shape of the tab bar
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: widthFactorTimesCount + widthFactor, y: rect.minY))
        // Add cubic Bézier curves to create a rounded shape for the tabs
        path.addCurve(to: CGPoint(x: widthFactorTimesCount, y: rect.midY),
                      control1: CGPoint(x: widthFactorTimesCount + 40, y: rect.minY),
                      control2: CGPoint(x: widthFactorTimesCount + 40, y: rect.minY + 50))
        path.addCurve(to: CGPoint(x: widthFactorTimesCount - widthFactor, y: rect.minY),
                      control1: CGPoint(x: widthFactorTimesCount - 40, y: rect.minY + 50),
                      control2: CGPoint(x: widthFactorTimesCount - 40, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - widthFactorTimesCount, y: rect.minY))
        
        // Return the completed path
        return path
    }
}
