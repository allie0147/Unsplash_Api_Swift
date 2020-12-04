//
//  WebKitViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/12/03.
//

import UIKit
import WebKit

class WebKitViewController: BaseViewController {

    var id: String?
    var uId: String?

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (id != nil) {
            let photoUrl = makeUrl(UNSPLASH_URL.PHOTO_URL + id!)
            loadWebPage(photoUrl)
        } else {
            let userUrl = makeUrl(UNSPLASH_URL.USER_URL + uId!)
            loadWebPage(userUrl)
        }
    }

    func loadWebPage(_ url: URL) {
        let myRequest = URLRequest(url: url)
        webView.scrollView.bounces = false
        webView.load(myRequest)
    }
    
    func makeUrl(_ string: String) -> URL {
        return URL(string: string)!
    }
}
