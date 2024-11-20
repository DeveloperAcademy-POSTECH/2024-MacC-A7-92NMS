//
//  OnboardingPage5View.swift
//  Spha
//
//  Created by LDW on 11/20/24.
//


import SwiftUI

struct OnboardingPage5View: View {
    
    var body: some View {
        VStack {
            Text("자동 스트레스 추적을 위해")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Text("Apple 건강에 대한 엑세스를 허용 해주세요")
                .customFont(.body_1)
                .foregroundStyle(.white)
            
            Spacer()
            
            ExampleView()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                        .edgesIgnoringSafeArea(.bottom),
                    alignment: .bottom
                )
    
            Spacer()
        }
        .padding()
        .background(.black)
    }
    
    private func ExampleView() -> some View {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundStyle(.white)
                .frame(height: 450)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text("확인")
                                .foregroundStyle(.blue)
                                .fontWeight(.bold)
                                .font(.system(size: 18))
                                .padding(.trailing, 16)
                        }
                        .padding(.bottom, 8)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.white)
                                .shadow(radius: 6)
                                .overlay {
                                    VStack{
                                        HStack{
                                            Spacer()
                                            
                                            Image(systemName: "suit.heart.fill")
                                                .resizable()
                                                .frame(width: 27, height: 25)
                                                .foregroundStyle(.pink)
                                                .padding(.top, 12)
                                                .padding(.trailing, 12)
                                        }
                                        Spacer()
                                    }
                                }
                        }
                        
                        Text("건강")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .padding(.top, 8)
                            .padding(.bottom, 20)
                        
                        HStack {
                            Text("모두 허용")
                                .foregroundStyle(.blue)
                                .padding(.leading, 24)
                            
                            Spacer()
                        }
                        .padding(.bottom, 16)
                        
                        HStack{
                            Spacer()
                            
                            VStack{
                                ToggleButton()
                                    .padding(.bottom, 20)
                                ToggleButton()
                                    .padding(.bottom, 20)
                                ToggleButton()
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
                .padding(.horizontal, 40)

        
    }
    
    private func ToggleButton() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 50, height: 30)
                .foregroundStyle(.green)
                .overlay {
                    HStack{
                        Spacer()
                        
                        Circle()
                            .frame(width: 27)
                            .foregroundStyle(.white)
                            .padding(.trailing, 1)
                    }
                }
        
        }
        
    }
    
}

#Preview {
    OnboardingPage5View()
}
