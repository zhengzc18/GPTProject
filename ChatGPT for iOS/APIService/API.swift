//
//  API.swift
//  ChatGPT for iOS
//
//  Created by JAESOON on 12/11/23.
//

import Foundation
import Alamofire
import Combine
class APIService {
    let baseUrl = "https://api.openai.com/v1/"
    
    func sendMessage(message:String) ->
    AnyPublisher<CompletionsResponse, Error> {
        let body = CompletionsBody(model: "text-davinci-003", prompt: message, temperature: 0.7, max_tokens: 256)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.APIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: CompletionsResponse.self) { response  in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
       
    }
}

struct CompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}

struct CompletionsResponse: Decodable {
    let id: String
    let choices: [CompletionsChoice]
}

struct CompletionsChoice: Decodable {
    let text: String
}
