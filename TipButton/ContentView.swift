//
//  ContentView.swift
//  TipButton
//
//  Created by ihenry on 2023/12/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LaunchAnimationView(){
            ContentView()
        }
        
        CustomButton(buttonTint:.blue) {
            HStack(spacing: 10) {
                Text("Login")
                Image(systemName: "chevron.right")
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
        } action: {
            try? await Task.sleep(for: .seconds(2))
            return .failed("Passworld Incorrect")
//            return .sucess
        }
        .buttonStyle(.opacityLess)
    }
}

#Preview {
    ContentView()
}
