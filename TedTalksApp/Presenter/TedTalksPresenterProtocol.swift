//
//  TedTalksPresenterProtocol.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 16/11/2021.
//

import Foundation

protocol TedTalksPresenterProtocol {
    var view: TedTalksViewProtocol? { get set }
    var tedTalks: [Talk]? { get set }
    var filteredTalks: [Talk] { get set }
    var parseError: ParseErrors? { get set }

    func getFilteredTalksCount() -> Int
    
    func getFilteredTalk(for talk: Int) -> Talk
    
    func filterTalks(filters: [String], text: String)
}
