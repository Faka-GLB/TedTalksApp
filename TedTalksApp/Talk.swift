//
//  Talk.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 04/11/2021.
//

import Foundation

struct Talk: Codable {
    let comments: Int
    let description: String
    let duration: Int
    let event: String
    let filmDate: Int
    let languages: Int
    let mainSpeaker: String
    let name: String
    let numSpeaker: Int
    let publishedDate: Int
    let speakerOccupation: String
    let tags: String
    let title: String
    let url: String
    let views: Int
    
    enum CodingKeys: String, CodingKey {
        case comments, description, duration, event, languages, name, tags, title, url, views
        case filmDate = "film_date"
        case mainSpeaker = "main_speaker"
        case numSpeaker = "num_speaker"
        case publishedDate = "published_date"
        case speakerOccupation = "speaker_occupation"
    }
    
    func isfiltered(_ filters: [String], input: String) -> Bool {
        var result = false
        filters.forEach({ (filter) in
            switch filter {
            case Filters.Event.rawValue: do {
                if self.event.contains(input) {
                    result = true
                }
            }
            case Filters.MainSpeaker.rawValue: do {
                if self.mainSpeaker.contains(input) {
                    result = true
                }
            }
            case Filters.Name.rawValue: do {
                if self.name.contains(input) {
                    result = true
                }
            }
            case Filters.Description.rawValue: do {
                if self.description.contains(input) {
                    result = true
                }
            }
            case Filters.Title.rawValue: do {
                if self.description.contains(input) {
                    result = true
                }
            }
            default:
                result = true
            }
        })
        return result
    }
}
