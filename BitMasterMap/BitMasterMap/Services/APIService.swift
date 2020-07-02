//
//  APIService.swift
//  BitMasterMap
//
//  Created by user167101 on 7/1/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import Foundation

class APIService {

    static let shared = APIService()

    private let okStatusCode = 200
    
    private var pageNumber = 1
    private let perPageCount = 20
    // Github api doesn't let to get more than 1000 repos
    private let limitRepoCount = 1000
    private var totalCount = 1
    
    private var searchResults = [RepoModel]()

    private var pageString: String {
        return "page=\(pageNumber)&per_page=\(perPageCount)"
    }
    
    var hasMore: Bool {
         searchResults.count < limitRepoCount && searchResults.count < totalCount
    }
    
    func getResults(searchText: String, completed: @escaping (Result<[RepoModel], ErrorMessage>) -> Void) {
        let urlString = "https://api.github.com/search/repositories?q=\(searchText)+in:name&sort=stars&order=desc&\(pageString)"
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            if let _ = error {
                completed(.failure(.invalidData))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == self?.okStatusCode else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let deconder = JSONDecoder()
                deconder.keyDecodingStrategy = .convertFromSnakeCase
                
                let json = try deconder.decode(ReposModel.self, from: data)
                guard let results =  json.items else {
                    throw ErrorMessage.invalidData
                }
                DispatchQueue.main.async {
                    strongSelf.totalCount = json.totalCount ?? 1
                    strongSelf.searchResults += results
                    completed(.success(strongSelf.searchResults))
                }
                
            } catch {
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }
    
    func increasePage() {
        pageNumber += 1
    }
    
    func rollBackPage() {
        if (pageNumber > 1) {
            pageNumber -= 1
        }
    }
    
    func resetPages() {
        pageNumber = 1
        searchResults = []
    }
}
