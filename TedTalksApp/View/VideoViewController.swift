//
//  VideoViewController.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 10/11/2021.
//

import Foundation
import UIKit
import WebKit

class VideoViewController: UIViewController {
    var talk: Talk? = nil
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var airDateUILabel: UILabel!
    @IBOutlet weak var viewsUILabel: UILabel!
    @IBOutlet weak var nameUILabel: UILabel!
    @IBOutlet weak var descriptionUILabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func setTalk(_ talk: Talk){
        self.talk = talk
    }
    
    private func configureView() {
        guard let displayTalk = talk else {
            return
        }
        titleUILabel.text = displayTalk.title
        let date = Date(timeIntervalSinceReferenceDate: Double(displayTalk.publishedDate / 1000))
        let onlyDate = date.description.split(separator: " ")
        airDateUILabel.text = "Date: \(onlyDate[0])"
        viewsUILabel.text = "Views: \(displayTalk.views.description)"
        nameUILabel.text = displayTalk.name
        descriptionUILabel.text = displayTalk.description
        videoWebView.load(URLRequest(url: URL(string: displayTalk.url)!))
    }
}
