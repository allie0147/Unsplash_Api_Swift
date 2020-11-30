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
                    let thumbnail = subJson["urls"]["thumb"].string ?? ""
                    let username = subJson["user"]["username"].string ?? ""
                    let likesCount = subJson["likes"].intValue
                    let createdAt = subJson["created_at"].string ?? ""
                    let photoItem = Photo(thumbnail: thumbnail, username: username, likeCount: likesCount, createdAt: createdAt)
                    // photo 배열에 추가
                    photos.append(photoItem)
                }
                if photos.count > 0 {
                    completion(.success(photos))
                }else {
                    completion(.failure(.noContent))
                }

            }) }
}
