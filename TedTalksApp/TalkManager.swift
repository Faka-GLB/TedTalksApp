//
//  TalkManager.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 04/11/2021.
//

import Foundation

enum ParseErrors: Error {
    case fileNotFound
    case invalidData
    case decodingProblem(String)
}

class TalkManager {
    func parseFromJson(onCompletion: @escaping (Result<[Talk], ParseErrors>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = Bundle.main.url(forResource: "talks", withExtension: "json")
            guard let myUrl = url else {
                onCompletion(.failure(.fileNotFound))
                return
            }
            guard let myData = try?
                    Data(contentsOf: myUrl) else {
                onCompletion(.failure(.invalidData))
                return
            }
            do {
                let talks = try JSONDecoder().decode([Talk].self, from: myData)
                onCompletion(.success(talks))
            } catch DecodingError.dataCorrupted(_) {
                onCompletion(.failure(.decodingProblem("Data corrupted")))
            } catch DecodingError.keyNotFound(let codingKey, _) {
                onCompletion(.failure(.decodingProblem(codingKey.stringValue)))
            } catch let error {
                onCompletion(.failure(.decodingProblem(error.localizedDescription)))
            }
        }
    }
}
