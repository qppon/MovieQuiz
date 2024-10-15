//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 9/18/24.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
