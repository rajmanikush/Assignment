//
//  PostListResponse.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

import Foundation

struct PostListResponse: Decodable {
    internal let postList: [Post]?
    internal let page: Int
    
    internal enum CodingKeys: String, CodingKey {
        case postList = "hits"
        case page
    }
}

struct Post: Decodable {
    internal let title: String
    internal let url: String?
    internal let author: String
    internal let points: Int
    internal let storyText: String?
    internal let storyTitle: String?
    internal let storyUrl: String?
    internal let createdAt: String
    internal var isSelected: Bool? = false
}
