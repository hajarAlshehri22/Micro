//
//  SplashScreen.swift
//  Micro
//
//  Created by Shahad Alzowaid on 15/10/1445 AH.
//
import SwiftUI
import AVFoundation



class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?

    func playSound() {
        guard let url = Bundle.main.url(forResource: "Jsound", withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("An error occurred while trying to play the sound.")
        }
    }
}


import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8  // Start from a smaller scale

    var body: some View {
        if isActive {
            SignIn()
        } else {
            ZStack {
                Image("Splash")
                VStack {
                    Image("LogoCard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 370, height: 330)
                        .scaleEffect(logoScale)
                        .padding()

                    Image("Jammah")
                        .resizable()
                        .frame(width: 270, height: 115)
                        .padding()
                }
            }
            .onAppear {
                SoundManager.shared.playSound()  // Play the sound
                withAnimation(.easeInOut(duration: 2.5)) {
                    logoScale = 1.1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashScreen()
}


