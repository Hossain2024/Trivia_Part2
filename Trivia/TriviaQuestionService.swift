//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Maliha Hossain on 3/25/25.
//

import Foundation

class TriviaQuestionService{
    static func fetchQuestion(amount:Int, category: Int, difficulty: String,  completion: (([TriviaQuestion]) -> Void)? = nil){
        let amount = "amount=\(amount)"
        let category = "category=\(category)"
        let difficulty = "difficulty=\(difficulty)"
        let type = "type=multiple"
        let parameters  = [amount, category, difficulty,type].joined(separator: "&")
        
        
        let url = URL (string: "https://opentdb.com/api.php?\(parameters)")!
        let task = URLSession.shared.dataTask(with: url){data, response,error in
            
            guard error == nil else{
                assertionFailure("Error: \(error!.localizedDescription)")
                        return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                assertionFailure("Invalid response")
                return
            }
            
            guard let data = data , httpResponse.statusCode == 200 else{
                assertionFailure("Invalid response status code : \(httpResponse)")
                return
            }
            
            let questions = parse(data: data)
            DispatchQueue.main.async{
                completion?(questions)
            }
            
            
            let decoder = JSONDecoder()
            
            let response = try! decoder.decode(TriviaAPIResponse.self, from: data)
                  DispatchQueue.main.async {
                      completion?(response.results)
                  }
        }
        
        task.resume()
        
        
    }
    
    private static func parse(data: Data) ->[TriviaQuestion]{
        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let result = jsonDictionary["results"] as! [[String:Any]]
        
        var triviaQuestions: [TriviaQuestion] = []
        
        for questionDict in result {
            let type = questionDict["type"] as! String
            let difficulty = questionDict["difficulty"] as! String
            let category = questionDict["category"] as! String
            let question = questionDict["question"] as! String
            let correctAnswer = questionDict["correct_answer"] as! String
            let incorrectAnswers = questionDict["incorrect_answers"] as! [String]
            
            let TriviaQuestion = TriviaQuestion(type:type, difficulty: difficulty, category: category, question: question, correctAnswer: correctAnswer, incorrectAnswers:incorrectAnswers)
            
            triviaQuestions.append(TriviaQuestion )
            
        }
        return triviaQuestions
    }
}
