//
//  UserInfo.swift
//  Micro
//
//  Created by Hajar Alshehri on 26/10/1445 AH.
//

import SwiftUI

struct UserInfo: View {
    @State private var name: String = ""
    @State private var selectedImage: Int?
    var body: some View {
        
        ZStack {
            Image("Splash")
            VStack {
                Image("Jammah").resizable().frame(width: 270, height: 115).padding()
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 325, height: 490)
                        .shadow(radius: 10) // Adding a shadow for better visibility
                        .cornerRadius(20) // Adding rounded corners
                    VStack() {
                        Text("معلوماتي")
                            .bold()
                            .foregroundColor(Color("AccentColor"))
                            .padding()
                        
                        Divider().frame(width: 280).padding(.bottom,25)
                        
                        Text("الإسم:")
                        
                            .padding(.trailing, 220)
                        
                        // TextField to enter the name
                        TextField("أدخل اسمك هنا", text: $name)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                            .frame(width: 280, height: 41) // Ensure the text field does not exceed the rectangle width
                            .background(Color.gray.opacity(0.2))
                        
                            .cornerRadius(15).padding(.bottom, 40)
                        
                        
                        Text("اختر شخصيتك:")
                            .padding(.trailing, 160)
                        
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(width: 280, height: 180)
                                .shadow(radius: 10) // Adding a shadow for better visibility
                                .cornerRadius(20)
                            
                            VStack {
                                HStack {
                                    // Each button now toggles the selected image state when clicked
                                    imageButton(id: 1, imageName: "image1")
                                    imageButton(id: 2, imageName: "image2")
                                    imageButton(id: 3, imageName: "image3")
                                }
                                HStack {
                                    imageButton(id: 4, imageName: "image4")
                                    imageButton(id: 5, imageName: "image5")
                                    imageButton(id: 6, imageName: "image6")
                                    
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                .padding(.bottom)
                Button("التالي") {
                    
                }
                .frame(width: 189, height: 48)
                .background(Color("AccentColor")) // Using custom accent color
                .foregroundColor(.white)
                .cornerRadius(24)
            }
        }
    }
    func imageButton(id: Int, imageName: String) -> some View {
        Button(action: {
            // Toggle selected image
            self.selectedImage = id
        }) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color("AccentColor"), lineWidth: selectedImage == id ? 4 : 0)
                )
        }
    }}



#Preview {
    UserInfo()
}
