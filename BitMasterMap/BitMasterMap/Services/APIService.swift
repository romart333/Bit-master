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
    
    func getResults(repoName: String, perPageCount: Int, pageNumber: Int, completed: @escaping (Result<ReposModel, ErrorMessage>) -> Void) {
        let urlString = "https://api.github.com/search/repositories?q=\(repoName)+in:name&sort=stars&order=desc&per_page=\(perPageCount)&page=\(pageNumber)"

        guard let url = URL(string: urlString) else {return}

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.invalidData))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == self.okStatusCode else {
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
                let results = try deconder.decode(ReposModel.self, from: data)
                completed(.success(results))
            } catch {
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }
}
