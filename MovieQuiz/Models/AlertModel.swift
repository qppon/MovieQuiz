//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 9/18/24.
//
import Foundation
struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var complection: () -> Void
}
