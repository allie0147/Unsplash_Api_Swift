//
//  User.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import Foundation

struct User: Codable {
    var username: String
    var name: String
    var profileImage: String
    var totalLikes: Int
    var totalPhotos: Int
}
