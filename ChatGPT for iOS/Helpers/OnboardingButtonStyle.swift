//
//  OnboardingButtonStyle.swift
//  ChatGPT for iOS
//
//  Created by JAESOON on 12/18/23.
//

import Foundation
import SwiftUI

struct OnboardingButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            Rectangle()
                .frame(width: 300, height: 50)
                .cornerRadius(100)
                .foregroundColor(Color("Button"))
                .shadow(color: Color("Shadow"), radius: 3, x: 5, y: 7)
                
                
            configuration.label
                .foregroundColor(Color("Text"))
                        
        
        }
    }
}
