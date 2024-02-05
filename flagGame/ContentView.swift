//
//  ContentView.swift
//  flagGame
//
//  Created by Dainis Putans on 03/02/2024.
//

import SwiftUI

// used line 72
struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: 5)
    }
}
// used line 76
struct SpacingVStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
    }
}

struct ContentView: View {

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var showingNumberOfQuestions = false
    @State private var scoreTitle = ""
    @State private var userScore: Int = 0
    @State private var numberOfQuestions: Int = 0

    var body: some View {

        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
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
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .modifier(FlagImage())
                        }
                    }
                }
                .modifier(SpacingVStack())

                Spacer()
                Spacer()

                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        .alert("Game Over", isPresented: $showingNumberOfQuestions) {
            Button("Restart the Game", action: resetGame)
        } message: {
            Text("Your final score is \(userScore)")
        }

    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            numberOfQuestions += 1
        }
        else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            userScore -= 1
            numberOfQuestions += 1
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if numberOfQuestions >= 8 {
            showingNumberOfQuestions = true
        }
    }

    func resetGame() {
        if showingNumberOfQuestions == true {
            userScore = 0
            numberOfQuestions = 0
            self.showingNumberOfQuestions = false
        }
    }
}

#Preview {
    ContentView()
}
