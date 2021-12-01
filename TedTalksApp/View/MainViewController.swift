//
//  ViewController.swift
//  TedTalksApp
//
//  Created by Facundo Martinez on 04/11/2021.
//

import UIKit
import MultiSelectSegmentedControl
import Lottie

enum Filters: String {
    case Event = "Event", MainSpeaker = "Main Speaker", Title = "Title", Name = "Name", Description = "Description"
}

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageUILabel: UILabel!
    @IBOutlet weak var talksTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterMultiSelectSegmentedControl: MultiSelectSegmentedControl!
    @IBOutlet weak var loaderView: AnimationView!
    
    lazy var presenter: TedTalksPresenterProtocol = TedTalksPresenter(view: self as TedTalksViewProtocol)
    
    override func viewDidLoad() {    
        super.viewDidLoad()
        startLoader()
        presenter.getTalks()
        stopLoader()
        talksTableView.isHidden = true
        configureTable()
        filterMultiSelectSegmentedControl.items = [Filters.Event.rawValue, Filters.MainSpeaker.rawValue, Filters.Title.rawValue, Filters.Name.rawValue, Filters.Description.rawValue]
        }
    
    private func startLoader() {
        self.loaderView.contentMode = .scaleAspectFit
        self.loaderView.loopMode = .loop
        self.loaderView.animationSpeed = 0.5
        self.loaderView.play()
    }
    
    private func stopLoader() {
        self.loaderView.stop()
        self.loaderView.isHidden = true
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? true || searchBar.text == searchBar.placeholder {
            talksTableView.isHidden = true
        }
        messageUILabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        presenter.filterTalks(filters: filterMultiSelectSegmentedControl.selectedSegmentTitles, text: searchText)
        activityIndicator.stopAnimating()
        talksTableView.isHidden = false
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getFilteredTalksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let talk = presenter.getFilteredTalk(for: indexPath.row)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row <= presenter.getFilteredTalksCount() else {
            print("Out of range")
            return
        }
        performSegue(withIdentifier: "videoDetail", sender: presenter.getFilteredTalk(for: indexPath.row))
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail",
                   let destinationViewController = segue.destination as? VideoViewController,
                   let selectedTedTalk = sender as? Talk {
                    destinationViewController.setTalk(selectedTedTalk)
                }
    }
}

extension MainViewController: TedTalksViewProtocol {
    func reloadData() {
        guard presenter.apiError != nil else {
            talksTableView.reloadData()
            return
        }
        switch presenter.apiError {
        case .fileNotFound:
            self.messageUILabel.text = "File not found"
        case .decodingProblem(let problem):
            self.messageUILabel.text = "There was a problem decoding the data: \(problem)"
        default:
            self.messageUILabel.text = "There was a problem"
        }
        self.messageUILabel.isHidden = false
    }
}
