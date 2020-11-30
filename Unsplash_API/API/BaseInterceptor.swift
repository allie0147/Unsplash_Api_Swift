//
//  BaseInterceptor.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
        var request = urlRequest

        // header 추가
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")

        // 공통 param 추가
        var dictionary = [String: String]()
        dictionary.updateValue(API.CLIENT_ID, forKey: "client_id")
        do {
            request = try URLEncodedFormParameterEncoder().encode(dictionary, into: request)
        } catch {
            print(error)
        }
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")

        completion(.doNotRetry)

    }

}
