//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaAPIResponse: Decodable {
    let results: [TriviaQuestion] // The list of trivia questions
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}
struct TriviaQuestion: Decodable{
  let type: String
  let difficulty: String
  let category: String
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
        
    }
}
   


