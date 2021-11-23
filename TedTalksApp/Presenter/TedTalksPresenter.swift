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
    var parseError: ParseErrors? = nil
    
    init(view: TedTalksViewProtocol) {
        self.view = view
        getTalks()
    }
    
    private func getTalks() {
        TalkManager().parseFromJson( fileName: "talks") {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let talks):
                    self.tedTalks = talks
                case .failure(let error):
                    switch error {
                    case .decodingProblem:
                        self.parseError = error
                    case .fileNotFound:
                        self.parseError = error
                    case .invalidData:
                        self.parseError = error
                        self.tedTalks = []
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
