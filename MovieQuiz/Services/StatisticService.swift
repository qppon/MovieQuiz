//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 9/25/24.
//

import Foundation

class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: "correctAnswears")
        }
        set {
            storage.set(newValue, forKey: "correctAnswears")
        }
    }
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: "gamesCount")
        }
        set {
            storage.set(newValue, forKey: "gamesCount")
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: "correct")
            let total = storage.integer(forKey: "total")
            let date = storage.object(forKey: "date") as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: "correct")
            storage.set(newValue.total, forKey: "total")
            storage.set(newValue.date, forKey: "date")
        }
    }
    
    var totalAccuracy: Double {
        if gamesCount != 0 {
            return Double(correctAnswers) / Double(bestGame.total * gamesCount) * 100
        }
        return 10
    }
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        gamesCount += 1
        print(correctAnswers)
        if count > bestGame.correct {
            let date = Date()
            bestGame = GameResult(correct: count, total: amount, date: date)
        }
    }
    
    
}
