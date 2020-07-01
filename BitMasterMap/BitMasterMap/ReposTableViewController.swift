//
//  ViewController.swift
//  BitMasterMap
//
//  Created by user167101 on 6/13/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import UIKit

class ReposTableViewController: UIViewController, UISearchBarDelegate {
    
    private let perPageCount = 20
    
    private var currentPageNumber = 1
    
    private let startPageNumber = 1
    
    // Github api doesn't let to get more than 1000 repos
    private let limitRepoCount = 1000
    
    @IBOutlet private weak var emptyDataLabel: UILabel!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let cellIndentifier = "tableCell"
    
    private var repos = [RepoModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
        emptyDataLabel.isHidden = false
        tableView.isHidden = true
        print("loaded")
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            tableView.isHidden = true
            emptyDataLabel.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text, !text.isEmpty {
            tableView.isHidden = false
            emptyDataLabel.isHidden = true
            fetchRepositories(repoName: text)
        }
    }
    
    func openMap(repoModel: RepoModel) {
        let mapViewContoller = MapsViewController()
        mapViewContoller.repoModel = repoModel
        if let topVC = self.navigationController?.topViewController, topVC.isKind(of: self.classForCoder) {
            self.navigationController?.pushViewController(mapViewContoller, animated: true)
        }
    }
    
    func fetchRepositories(repoName: String) {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
//        Это должно быть в серч баре. Запрос в сеть каждые о.5 секунд
//        }
        
        APIService.shared.getResults(repoName: repoName, perPageCount: perPageCount, pageNumber: currentPageNumber) {[weak self] result in
                    
            switch result {
            case .success(let results):
                guard let repos = results.items else {return}
                self?.repos = repos
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

                case .failure(let error):
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: error.rawValue, message: nil, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                    print(error)
            }
        }
    }
    
//    func getRepositories(q: String) {
//
//        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(q)+in:name&sort=stars&order=desc&per_page=\(perPageCount)&page=\(currentPageNumber)") else { return }
//        let urlRequest = URLRequest(url: url)
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
//            guard let data = data else { return }
//
//            let jsonDecoder = JSONDecoder()
//            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
////            var repos: ReposModel!
////            do {
////                 repos = try jsonDecoder.decode(ReposModel.self, from: data)}
////                catch {
////                    print(error)
////                }
//
//            guard let repos = try? jsonDecoder.decode(ReposModel.self, from: data) else {return}
//
//            guard let strongSelf = self else { return }
//            guard let items = repos.items else { print("items 0");return }
//
//            strongSelf.repos = items
//
//            DispatchQueue.main.async { [weak self] in
//                guard let strongSelf = self else { return }
//                strongSelf.tableView.reloadData()
//                strongSelf.increasePageNumber()
//            }
//        }
//        dataTask.resume()
//    }
    
    func increasePageNumber() {
//        currentPageNumber += perPageCount
    }
    
    func wasLimitReached() -> Bool {
        return false
//        return currentPageNumber * perPageCount >= limitRepoCount
    }
}

extension ReposTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
//    func tableView(_ tableView: UITableView,
//                   willDisplay cell: UITableViewCell,
//                   forRowAt indexPath: IndexPath) {
//        
//        if indexPath.row > repos.count && !wasLimitReached() {
//            increasePageNumber()
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? RepoTableViewCell
        let repoModel = self.repos[indexPath.row]
        
        cell?.setBackgroundColorForOpenMapButton(color: UIColor.blue)
        cell?.configureCellWith(repoModel: repoModel)
        cell?.closure = { [weak self] in
            self?.openMap(repoModel: repoModel)
        }
           
        return cell ?? UITableViewCell()
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

