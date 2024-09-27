//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 9/25/24.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
