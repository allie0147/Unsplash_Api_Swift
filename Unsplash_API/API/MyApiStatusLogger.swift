//
//  MyApiStatusLogger.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import Foundation
import Alamofire

final class MyApiStatusLogger: EventMonitor {

    let queue = DispatchQueue(label: "MyApiStatusLogger")

    // request 부분
//    func requestDidResume(_ request: Request) {
//        print("MyApiStatusLogger - requestDidResume() called")
//        debugPrint(request)
//    }
    
    // response 부분
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let statusCode = request.response?.statusCode else {
            return
        }
        print("MyApiStatusLogger - request() called / status code : \(statusCode)")
    }



}
