//
//  MyLogger.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor {

    let queue = DispatchQueue(label: "APIlog")

    // request 부분
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume() called")
        debugPrint(request)
    }
    
    
    // response 부분
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request() called")
        debugPrint(response)
    }



}
