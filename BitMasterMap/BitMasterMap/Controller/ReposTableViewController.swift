//
//  ViewController.swift
//  BitMasterMap
//
//  Created by user167101 on 6/13/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import UIKit

class ReposTableViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet private weak var emptyDataLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let repoCellIndentifier = "repoCell"
    private let loadingCellIndentifier = "loadingCell"
    
    private var repos = [RepoModel]()
    
    private var searchBarText: String? {
        searchBar.text
    }
    
    private var needNextPage: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
        emptyDataLabel.isHidden = false
        tableView.isHidden = true
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ReposTableViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReposTableViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.setBottomInset(to: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        tableView.setBottomInset(to: 0)
    }
    
    private weak var timer: Timer?
    private let fetchTimeInterval = 0.5
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            tableView.isHidden = true
            emptyDataLabel.isHidden = false
            return
        }
        
        tableView.isHidden = false
        emptyDataLabel.isHidden = true
        APIService.shared.resetPages()
        needNextPage = false
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: self.fetchTimeInterval, target: self, selector: #selector(fetchRepositories), userInfo: nil, repeats: false)
            
    }
    
    func openMap(repoModel: RepoModel) {
        
        let mapViewContoller = MapsViewController()
        mapViewContoller.repoModel = repoModel
        if let topVC = self.navigationController?.topViewController, topVC.isKind(of: self.classForCoder) {
            self.navigationController?.pushViewController(mapViewContoller, animated: true)
        }
    }
    
    @objc func fetchRepositories() {
        var pageWasIncreased: Bool = false
        if (needNextPage && APIService.shared.hasMore) {
            APIService.shared.increasePage()
            pageWasIncreased = true
        }
        guard let searchText = searchBarText, !searchText.isEmpty else {
            if pageWasIncreased {
                APIService.shared.rollBackPage()
            }
            return
        }
        APIService.shared.getResults(searchText: searchText) {[weak self] result in
                    
            switch result {
            case .success(let results):
                    self?.repos = results
                    self?.tableView.reloadData()

            case .failure(let error):
                DispatchQueue.main.async {
                    if pageWasIncreased {
                        APIService.shared.rollBackPage()
                    }
                    let ac = UIAlertController(title: error.rawValue, message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self?.present(ac, animated: true)
                }
                print(error)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension ReposTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == repos.count - 1 && APIService.shared.hasMore {
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellIndentifier)
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: repoCellIndentifier, for: indexPath) as? RepoTableViewCell
        let repoModel = self.repos[indexPath.row]
        
        cell?.configureCellWith(repoModel: repoModel)
        cell?.closure = { [weak self] in
            self?.openMap(repoModel: repoModel)
        }
        
        return cell ?? UITableViewCell()
    }
    
//     func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        table
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repos.count - 1 {
            needNextPage = true
            fetchRepositories()
        }
    }
    
    
}

extension ReposTableViewController: UITableViewDelegate {

}

extension UITableView {
    
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}
