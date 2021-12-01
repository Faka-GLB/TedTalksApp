//
//  TalkManager.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 04/11/2021.
//

import Foundation

enum ApiErrors: Error {
    case fileNotFound
    case invalidData
    case decodingProblem(String)
    case wrongUrl
    case invalidResponse
    case pageNotFound
    case serverError
    case genericError
}

class TalkManager {
    func parseFromJson(fileName: String, onCompletion: @escaping (Result<[Talk], ApiErrors>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = Bundle.main.url(forResource: fileName, withExtension: "json")
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
    
    func getFromServer(onCompletion: @escaping (Result<[Talk], ApiErrors>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringCacheData
            config.urlCache = nil
            let url = URL(string: "https://gist.githubusercontent.com/gonzaloperretti/0e79c229a5de5bacdd07f402c1a3cefd/raw/dc022b40d572a8b35f3b7d1b69ec60759a715b61/tedTalks.json")
            guard let myUrl = url else {
                onCompletion(.failure(.wrongUrl))
                return
            }
            let task = URLSession(configuration: config).dataTask(with: myUrl) { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    onCompletion(.failure(.invalidResponse))
                    return
                }
                switch httpResponse.statusCode {
                case 200...299:
                    guard let recivedData = data else {
                        onCompletion(.failure(.invalidData))
                        return
                    }
                    do {
                        let talks = try JSONDecoder().decode([Talk].self, from: recivedData)
                        onCompletion(.success(talks))
                    } catch DecodingError.dataCorrupted(_) {
                        onCompletion(.failure(.decodingProblem("Data corrupted")))
                    } catch DecodingError.keyNotFound(let codingKey, _) {
                        onCompletion(.failure(.decodingProblem(codingKey.stringValue)))
                    } catch let error {
                        print(error)
                        onCompletion(.failure(.decodingProblem(error.localizedDescription)))
                    }
                case 404:
                    onCompletion(.failure(.pageNotFound))
                case 500...599:
                    onCompletion(.failure(.serverError))
                default:
                    onCompletion(.failure(.genericError))
                }
            }
            task.resume()
        }
    }
}
