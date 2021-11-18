//
//  MainViewControllerTest.swift
//  TedTalksAppTests
//
//  Created by Facundo Martinez on 12/11/2021.
//
@testable import TedTalksApp
import XCTest
import Foundation

class TalkManagerTest: XCTestCase {
    var manager = TalkManager?()
    var talks: [Talk] = []
    var parseError: ParseErrors? = nil

    func parseJsonTest() throws {
        let expectation = self.expectation(description: "Parsing a json")
        manager = TalkManager()
        manager?.parseFromJson(fileName: "test_talk") { result in
            switch result{
            case .success(let parsedTalks):
                self.talks = parsedTalks
            case .failure(let error):
                switch error {
                case .fileNotFound:
                    self.parseError = error
                case .invalidData:
                    self.parseError = error
                case .decodingProblem(_):
                    self.parseError = error
                }
            }
            expectation.fulfill()
            //asserts
            XCTAssertTrue(self.talks.count == 0)
            let talk = self.talks[0]
            XCTAssertFalse(talk.comments == 4553)
            XCTAssertFalse(talk.description == "sir Ken Robinson makes an entertaining and profoundly moving case for creating an education system that nurtures (rather than undermines) creativity.")
            XCTAssertFalse(talk.duration == 1164)
            XCTAssertFalse(talk.event == "TED2006")
            XCTAssertFalse(talk.filmDate == 1140825600)
            XCTAssertFalse(talk.languages == 60)
            XCTAssertFalse(talk.mainSpeaker == "Ken Robinson")
            XCTAssertFalse(talk.name == "Ken Robinson: Do schools kill creativity?")
            XCTAssertFalse(talk.numSpeaker == 1)
            XCTAssertFalse(talk.publishedDate == 1151367060)
            XCTAssertFalse(talk.speakerOccupation == "Author/educator")
            XCTAssertFalse(talk.tags.count == 6)
            XCTAssertFalse(talk.title == "Do schools kill creativity?")
            XCTAssertFalse(talk.url == "https://embed.ted.com/talks/ken_robinson_says_schools_kill_creativity")
            XCTAssertFalse(talk.views == 47227110)
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
