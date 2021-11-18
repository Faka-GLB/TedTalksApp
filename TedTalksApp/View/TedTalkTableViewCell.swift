//
//  TedTalkTableViewCell.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 04/11/2021.
//

import UIKit
import AVFoundation

class TedTalkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var talkThumbnailImageView: UIImageView!
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var descriptionUILabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    static let identifier = "TedTalkTableViewCell"
    
    static func getIdentifier() -> String {
        return identifier
    }
    
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ talk: Talk) {
        titleUILabel.text = talk.title
        descriptionUILabel.text = talk.description
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            guard let url = NSURL(string: talk.url) else {
                return
            }
            do{
                let htmlString = try String(contentsOf: url as URL, encoding: .ascii)
                let link = self.checkForUrls(text: htmlString)
                let imageUrl = URL(string: link)
                guard let url = imageUrl else {
                    return
                }
                UIImage.loadFrom(url) { image in
                    self.talkThumbnailImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error loading image")
            }
        }
    }
    
    private func checkForUrls(text: String) -> String {
        var imageUrl: String = ""
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            let url = text[range]
            if url.contains("image") {
                imageUrl = String(url)
            }
        }
        return imageUrl
    }
    
}

extension UIImage {
    public static func loadFrom(_ url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
