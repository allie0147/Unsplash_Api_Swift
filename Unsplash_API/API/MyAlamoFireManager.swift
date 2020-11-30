//
//  MyAlamoFireManager.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import UIKit
import Alamofire

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
}
