//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 9/25/24.
//

import Foundation

class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correctAnswears
        case gamesCount
        case correct
        case total
        case date
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswears.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswears.rawValue)
        }
    }
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
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
