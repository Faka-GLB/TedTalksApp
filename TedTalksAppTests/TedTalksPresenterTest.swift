//
//  TedTalksPresenterTest.swift
//  TedTalksAppTests
//
//  Created by Facundo Martinez on 04/11/2021.
//

import XCTest
@testable import TedTalksApp

class ViewMock: TedTalksViewProtocol {
    func reloadData() {
        
    }
}

class TedTalksPresenterTest: XCTestCase {
    var presenter: TedTalksPresenterProtocol?
    let viewMock = ViewMock()
    
    override func setUpWithError() throws {
        presenter = TedTalksPresenter(view: viewMock)
    }

    func filterTalkTest() throws {
        let filter: [String] = ["Main Speaker"]
        presenter?.filterTalks(filters: filter, text: "Elon")
        XCTAssertTrue(presenter?.getFilteredTalksCount() == 0)
        }
    
    func getFilteredCountTest() throws {
        let filter: [String] = ["Main Speaker"]
        presenter?.filterTalks(filters: filter, text: "Elon")
        XCTAssertFalse(presenter?.getFilteredTalksCount() == 2)
    }
    
    func getFilteredTalk() throws {
        let filter: [String] = ["Main Speaker"]
        presenter?.filterTalks(filters: filter, text: "Elon")
        let talk = presenter?.getFilteredTalk(for: 0)
        XCTAssertFalse(talk?.name == "Elon Musk: The mind behind Tesla, SpaceX, SolarCity ...")
    }
}
