//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 曹琴 on 2019/12/19.
//  Copyright © 2019 csike. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var showAnimation = false
    
    @State private var selectedAnswer = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.init(.systemBackground), .init(.blue)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 20)
            
            VStack(spacing: 50) {
                VStack {
                    Text("Tap the flag of")
                        .font(.subheadline)
                    
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .frame(width: 300)
                }.padding(.top, 20)
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.showAnimation = true
                        self.flagTapped(number)
                    }){
                        FlagImage(name: self.countries[number])
                            .overlay(Color.red.opacity(self.showAnimation && number != self.correctAnswer ? 0.8 : 0)
                                .cornerRadius(10))
                            .opacity(self.showAnimation && number != self.selectedAnswer ? 0.2 : 1)
                            .rotation3DEffect(self.showAnimation && number == self.selectedAnswer ? .degrees(360) : .degrees(0), axis: self.correctAnswer == self.selectedAnswer ? (x:1, y:1, z:1) : (x:0, y:1, z:0))
                            .scaleEffect(self.showAnimation && number == self.selectedAnswer ? 1.7 : 1)
                            .animation(Animation.interpolatingSpring(stiffness: 7, damping: 3)
                                .speed(5)
                                .delay(0.2)
                            )
                    }
                }
                
                VStack {
                    Text("Current score:")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Text("\(currentScore)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("That's the flag of \(self.countries[selectedAnswer])"), dismissButton: .default(Text("Continue")){
                self.askQuestion()
                self.showAnimation = false
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            currentScore += 1
            scoreTitle = "Correct"
        } else {
            currentScore -= 1
            scoreTitle = "Wrong!"
        }
        selectedAnswer = number
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.selectedAnswer == self.correctAnswer {
                self.showAnimation = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                    self.askQuestion()
                }
            } else {
                self.showingScore = true
            }
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .light)
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}
