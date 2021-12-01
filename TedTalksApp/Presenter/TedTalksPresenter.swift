//
//  TedTalksPresenter.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 16/11/2021.
//

import Foundation

class TedTalksPresenter: TedTalksPresenterProtocol {

    var view: TedTalksViewProtocol?
    var tedTalks: [Talk]? = []
    var filteredTalks: [Talk] = [] {
        didSet {
            view?.reloadData()
        }
    }
    var apiError: ApiErrors? = nil
    
    init(view: TedTalksViewProtocol) {
        self.view = view
    }
    
   func getTalks() {
        TalkManager().getFromServer {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let talks):
                    self.tedTalks = talks
                case .failure(let error):
                    switch error {
                    case .decodingProblem:
                        self.apiError = error
                    case .fileNotFound:
                        self.apiError = error
                    case .invalidData:
                        self.apiError = error
                        self.tedTalks = []
                    case .wrongUrl:
                        self.apiError = error
                    case .invalidResponse:
                        self.apiError = error
                    case .pageNotFound:
                        self.apiError = error
                    case .serverError:
                        self.apiError = error
                    case .genericError:
                        self.apiError = error
                    }
                }
            }
        }
    }
    
    func getFilteredTalksCount() -> Int {
        return self.filteredTalks.count
    }
    
    func getFilteredTalk(for talk: Int) -> Talk {
        return self.filteredTalks[talk]
    }
    
    func filterTalks(filters: [String], text: String) {
        self.filteredTalks = []
            tedTalks?.forEach({ (talk) in
                if talk.isfiltered(filters, input: text) {
                    self.filteredTalks.append(talk)
                }
            })
    }
}
