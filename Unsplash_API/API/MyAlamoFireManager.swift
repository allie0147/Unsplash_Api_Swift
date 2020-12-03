//
//  MyAlamoFireManager.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import UIKit
import Alamofire
import SwiftyJSON

final class MyAlamofireManager {

    // singleton
    static let shared = MyAlamofireManager()

    // interceptor (여러개 가능)
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor()
        ])

    // logger (여러개 가능)
    let monitors = [MyLogger(), MyApiStatusLogger()] as [EventMonitor]

    // session
    let session: Session

    private init() {
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors)
    }

    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], MyError>) -> Void) {
        print("MyAlamofireManager - getPhotos() called / userInput: \(userInput)")
        self.session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                var photos = [Photo]()

                let jsonArray = responseJson["results"]
                print("jsonArray count: \(jsonArray.count)")
                for (index, subJson): (String, JSON) in jsonArray {
                    print("index : \(index), subJson: \(subJson)")
                    // 데이터 파싱
                    let photoId = subJson["id"].string ?? ""
                    let photoUrl = subJson["urls"]["small"].string ?? ""
                    let username = subJson["user"]["username"].string ?? ""
                    let likesCount = subJson["likes"].intValue
                    let createdAt = subJson["created_at"].string ?? ""
                    let photoItem = Photo(photoId: photoId, photoUrl: photoUrl, username: username, likeCount: likesCount, createdAt: createdAt)
                    // photo 배열에 추가
                    photos.append(photoItem)
                    print("getPhotos() - append : \(photoItem)")
                }
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
            }) }

    func getUsers(searchTerm userInput: String, completion: @escaping (Result<[User], MyError>) -> Void) {
        print("MyAlamofireManager - getUsers() called / userInput: \(userInput)")
        self.session
            .request(MySearchRouter.searchUsers(term: userInput))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                var users = [User]()

                let jsonArray = responseJson["results"]
                for (index, subJson): (String, JSON) in jsonArray {
                    print("index : \(index), subJson: \(subJson)")
                    let username = subJson["username"].string ?? ""
                    let name = subJson["name"].string ?? ""
                    let profileImage = subJson["profile_image"]["small"].string ?? ""
                    let totalLikes = subJson["total_likes"].intValue
                    let totalPhotos = subJson["total_photos"].intValue
                    let userItem = User(username: username, name: name, profileImage: profileImage, totalLikes: totalLikes, totalPhotos: totalPhotos)
                    users.append(userItem)
                }
                if users.count > 0 {
                    completion(.success(users))
                } else {
                    completion(.failure(.noContent))
                }
            })
    }
}
