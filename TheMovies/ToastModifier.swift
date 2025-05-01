//
//  ToastModifier.swift
//  TheMovies
//
//  Created by Amr Hassan on 01.05.25.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if !message.isEmpty {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    self.message = ""
                                }
                            }
                        }
                }
                .animation(.easeInOut, value: message)
            }
        }
    }
}

extension View {
    func toast(message: Binding<String>) -> some View {
        self.modifier(ToastModifier(message: message))
    }
}
