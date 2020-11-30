//
//  Photo.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import Foundation

struct Photo: Codable {
    var thumbnail: String
    var username: String
    var likeCount: Int
    var createdAt: String
}
