//
//  RepoModel.swift
//  BitMasterMap
//
//  Created by user167101 on 6/13/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import Foundation

struct ReposModel: Decodable {
    let items: [RepoModel]?
    let totalCount: Int?
}

public class RepoModel: NSObject,Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case stargazersCount
    }
    
    @objc public var name: String?
    @objc public var stargazersCount: NSNumber?

    @objc public var latitude = Float.random(in: -180...180)
    @objc public var longitude = Float.random(in: -180...180)
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount) as NSNumber
    }
}
