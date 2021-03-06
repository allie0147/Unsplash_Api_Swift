//
//  Constants.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import Foundation

enum SEGUE_ID {
    static let USER_LIST_VC = "goToUserList"
    static let PHOTO_COLLECTION_VC = "goToPhotoCollection"
    static let WEB_KIT_VC_PHOTO = "goToPhotoUnsplash"
    static let WEB_KIT_VC_USER = "goToUserUnsplash"
}

enum API {
    static let BASE_URL: String = "https://api.unsplash.com/"
    static let CLIENT_ID: String = "F4NZLg5-NEUVL6kV26a3ur-m7g0v0V8mA8cfPOX2HBI"
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}

enum UNSPLASH_URL {
    static let PHOTO_URL: String = "https://unsplash.com/photos/"
    static let USER_URL: String = "https://unsplash.com/@"
}
