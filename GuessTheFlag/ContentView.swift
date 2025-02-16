//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aytan Gurbanova on 07.02.2025.
//

import SwiftUI

struct ContentView: View {
  @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
  @State private var correctAnswer = Int.random(in: 0...2)
  
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var userScore = 0
  @State private var endOfRound = false
  @State private var questionNumber = 1
  @State private var rotationAmounts = [0.0, 0.0, 0.0]
  @State private var selectedFlag: Int? = nil
  var body: some View {
    ZStack {
      RadialGradient(stops: [
        .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
        .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
      ], center: .top, startRadius: 200, endRadius: 700)
      .ignoresSafeArea()
      
      VStack {
        Spacer()
        Text("Guess the Flag")
          .font(.largeTitle.bold())
          .foregroundStyle(.white)
        
        VStack(spacing: 15) {
          VStack {
            Text("Tap the flag of")
              .foregroundStyle(.secondary)
              .font(.subheadline.weight(.heavy))
            Text(countries[correctAnswer])
              .font(.largeTitle)
              .fontWeight(.semibold)
          }
          ForEach(0..<3) { number in
            Button {
              withAnimation {
                rotationAmounts[number] += 360
                selectedFlag = number
                flagTapped(number)
              }
              if questionNumber != 8 {
                questionNumber += 1
              }
            } label: {
              FlagImage(countries: $countries, number: number)
                .opacity(selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                .rotation3DEffect(.degrees(rotationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                .scaleEffect(selectedFlag != nil && selectedFlag == number ? 1.2 : 1)
            }
            
          }
          
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 20))
        
        Spacer()
        Spacer()
        Text("Score: \(userScore)")
          .foregroundStyle(.white)
          .font(.title.bold())
        Text("Question \(questionNumber)/8")
        Spacer()
      }
      .padding()
    }
    .alert(scoreTitle, isPresented: $showingScore) {
      Button("Continue", action: askQuestion)
    } message: {
      Text("Your score is \(userScore)")
    }
    .alert(scoreTitle, isPresented: $endOfRound) {
      Button("Reset", action: reset)
    }
  }
  
  struct FlagImage: View {
    @Binding var countries: [String]
    var number: Int
    
    var body: some View {
      Image(countries[number])
        .clipShape(Capsule())
        .shadow(radius: 20)
    }
  }
  
  func flagTapped(_ number: Int) {
    if number == correctAnswer {
      scoreTitle = "Correct!"
      userScore += 10
    } else {
      scoreTitle = "Wrong! That's the flag of \(countries[number])"
      if userScore > 0 {
        userScore -= 5
      }
    }
    showingScore = true
    if questionNumber == 8 {
      endOfRound = true
      scoreTitle = "Game Over! Your final score is \(userScore)"
      showingScore = false
    }
  }
  
  func reset() {
    userScore = 0
    questionNumber = 1
  }
  
  func askQuestion() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    selectedFlag = nil
  }
}

#Preview {
  ContentView()
}
