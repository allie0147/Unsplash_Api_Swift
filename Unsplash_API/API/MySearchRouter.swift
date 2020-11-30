//
//  MySearchRouter.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import Foundation
import Alamofire

// 검색 관련 api
enum MySearchRouter: URLRequestConvertible {
    case searchPhotos (term: String)
    case searchUsers (term: String)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }

    var method: HTTPMethod {
//        return .get

        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }

//        switch self {
//        case .searchPhotos: return .get
//        case .searchUsers: return .get
//        }
    }

    var endPoint: String {
        switch self {
        case .searchPhotos: return "photos"
        case .searchUsers: return "users"
        }
    }

    var parameters: [String: String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query": term]
        }
    }

    // 실제 api 요청시 발동
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        print("MySearchRouter - asURLReqeust() called / url : \(url)")

        var request = URLRequest(url: url)

        request.method = method

        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        switch self {
//        case let .get(parameters):
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        case let .post(parameters):
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        }

        return request
    }
}
