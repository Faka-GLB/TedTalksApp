//
//  ViewController.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 04/11/2021.
//

import UIKit
import MultiSelectSegmentedControl

enum Filters: String {
    case Event = "Event", MainSpeaker = "Main Speaker", Title = "Title", Name = "Name", Description = "Description"
}

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageUILabel: UILabel!
    @IBOutlet weak var talksTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterMultiSelectSegmentedControl: MultiSelectSegmentedControl!
    
    var tedTalks: [Talk]? = []
    var filteredTalks: [Talk] = [] {
        didSet {
            talksTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        talksTableView.isHidden = true
        configureTable()
        filterMultiSelectSegmentedControl.items = [Filters.Event.rawValue, Filters.MainSpeaker.rawValue, Filters.Title.rawValue, Filters.Name.rawValue, Filters.Description.rawValue]
        TalkManager().parseFromJson() {
            [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let talks):
                    self?.tedTalks = talks
                case .failure(let error):
                    switch error {
                    case .fileNotFound:
                        self?.messageUILabel.text = "File not found"
                    case .decodingProblem(let problem):
                        self?.messageUILabel.text = "There was a problem decoding the data: \(problem)"
                    default:
                        self?.messageUILabel.text = "There was a problem"
                    }
                    self?.messageUILabel.isHidden = false
                    self?.tedTalks = []
                }
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? true || searchBar.text == searchBar.placeholder {
            talksTableView.isHidden = true
        }
        filteredTalks = []
        messageUILabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let filters = filterMultiSelectSegmentedControl.selectedSegmentTitles
            tedTalks?.forEach({ (talk) in
                if talk.isfiltered(filters, input: searchText) {
                    filteredTalks.append(talk)
                }
            })
        activityIndicator.stopAnimating()
        talksTableView.isHidden = false
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTalks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let talk = filteredTalks[indexPath.row]
        let cellIdentifier = TedTalkTableViewCell.getIdentifier()
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TedTalkTableViewCell
        cell?.talkThumbnailImageView.image = UIImage(named: "thumbnail_placeholder")
        if cell == nil {
            cell = TedTalkTableViewCell()
        }
        cell?.configureCell(talk)
        return cell ?? UITableViewCell()
    }
    
    private func configureTable() {
        talksTableView.dataSource = self
        talksTableView.delegate = self
        talksTableView.register(TedTalkTableViewCell.getNib(), forCellReuseIdentifier: TedTalkTableViewCell.getIdentifier())
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard indexPath.row <= filteredTalks.count else {
            print("Out of range")
            return
        }
        performSegue(withIdentifier: "videoDetail", sender: filteredTalks[indexPath.row])
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail",
                   let destinationViewController = segue.destination as? VideoViewController,
                   let selectedTedTalk = sender as? Talk {
                    destinationViewController.setTalk(selectedTedTalk)
                }
    }
}
