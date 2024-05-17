//
//  ContentView.swift
//  HWS_GuessTheFlag
//
//  Created by Maria Vounatsou on 16/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var usersScore = 0
    @State private var counting = 0
    @State private var finalAlert = false
    @State private var messageScreen = ""
    @State private var selectedFlag = -1
    
    enum UserScore {
        case higherScore(score: Int)
        case goodPerformance(score: Int)
        case needMorePractice(score: Int)
        case encouragement(score: Int)
        case needPractice(score: Int)
        
        static func from(score: Int) -> UserScore {
            switch score {
            case 8:
                return .higherScore(score: score)
            case 6, 7:
                return .goodPerformance(score: score)
            case 3, 4, 5:
                return .needMorePractice(score: score)
            case 1, 2:
                return .encouragement(score: score)
            default:
                return .needPractice(score: score)
            }
        }
        
        func getMessage() -> String {
                switch self {
                case .higherScore:
                    return "You reach the higher score"
                case .goodPerformance:
                    return "Good job"
                case .needMorePractice:
                    return "You need more Practice"
                case .encouragement:
                    return "Come on dude!"
                case .needPractice:
                    return "You definitely need Practice"
                }
            }
    }
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red:0.76, green: 0.15, blue: 0.2), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
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
                            FlagImage(name: countries[number])
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                                .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                                .animation(.default, value: selectedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(usersScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(usersScore)")
                .fontWeight(.bold)
        }
        
        .alert("You reach the end", isPresented: $finalAlert) {
            Button("The game will now restart", action: reset)
        } message: {
            Text("Your final score is: \(usersScore).\(UserScore.from(score: usersScore).getMessage())")
                .fontWeight(.bold)
        }
    }
    
    func flagTapped (_ number: Int) {
        
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct you Got it!!"
            usersScore += 1
        } else {
            scoreTitle = """
                         ...mmm No!
                         That's the flag of \(countries[number])
                         """
            usersScore -= 1
        }
        counting += 1
        showingScore = true
        
        if counting == 8 {
            finalAlert = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
    
    func reset() {
        usersScore = 0
        counting = 0
        showingScore = false
        askQuestion()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
