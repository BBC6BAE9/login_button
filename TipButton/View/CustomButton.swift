//
//  CustomButton.swift
//  TipButton
//
//  Created by ihenry on 2023/12/15.
//

import SwiftUI

struct CustomButton<ButtonContent:View>: View {
    
    var buttonTint:Color = .white
    var content:() -> ButtonContent
    /// Button Action
    var action:() async -> TaskStatus

    /// View Property
    @State private var isLoading:Bool = false
    @State private var taskStatus:TaskStatus = .idle
    @State private var isFailed:Bool = false
    @State private var wiggle:Bool = false

    /// Popup Properties
    @State private var showPopup:Bool = false
    @State private var popupMessage:String = ""

    var body: some View {
        Button(action: {
            Task{
                isLoading = true
                let taskStatus = await action()
                switch taskStatus {
                case .idle:
                    isFailed = false
                case .failed(let string):
                    isFailed = true
                    popupMessage = string
                case .sucess:
                    isFailed = false
                    
                }
                self.taskStatus = taskStatus
                
                if (isFailed){
                    wiggle.toggle()
                }
            
                try? await Task.sleep(for: .seconds(0.8))
            
                if (isFailed){
                    showPopup = true
                }
                
                self.taskStatus = .idle
                isLoading = false
            }
        }, label: {
            content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .opacity(isLoading ? 0 : 1)
                .lineLimit(1)
                .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
                .background(Color(taskStatus == .idle ? buttonTint : taskStatus == .sucess ? .green :.red).shadow(.drop(color: .black.opacity(0.15), radius: 6)), in:.capsule)
                .overlay {
                    if isLoading && taskStatus == .idle {
                        ProgressView()
                    }
                }
                .overlay {
                    if taskStatus != .idle {
                        Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                        
                }
                .wiggle(animate: wiggle)
        })
        .disabled(isLoading)
        .popover(isPresented: $showPopup, content: {
            Text(popupMessage)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal)
                .presentationCompactAdaptation(.popover)
        })
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: taskStatus)

    }
}

/// Custom opacity less button style
extension ButtonStyle where Self == OpacityLessButton {
    static var opacityLess:Self {
        Self()
    }
}

struct OpacityLessButton:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
/// wiggle extension
extension View{
    @ViewBuilder
    func wiggle(animate:Bool) -> some View {
        self.keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
            view
                .offset(x: value)
        } keyframes: { _ in
            KeyframeTrack {
                CubicKeyframe(0, duration: 0.05)
                CubicKeyframe(-5, duration: 0.05)
                CubicKeyframe(5, duration: 0.05)
                CubicKeyframe(-5, duration: 0.05)
                CubicKeyframe(5, duration: 0.05)
                CubicKeyframe(-5, duration: 0.05)
                CubicKeyframe(5, duration: 0.05)
                CubicKeyframe(-5, duration: 0.05)
                CubicKeyframe(5, duration: 0.05)
                CubicKeyframe(-5, duration: 0.05)
                CubicKeyframe(5, duration: 0.05)
            }
        }

    }
    
}

enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case sucess
}

#Preview {
    ContentView()
}
