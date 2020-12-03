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

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebPage(id!)
    }

    func loadWebPage(_ id: String) {
        let myUrl = URL(string: UNSPLASH_URL.PHOTO_URL + id)
        let myRequest = URLRequest(url: myUrl!)
        webView.scrollView.bounces = false
        webView.load(myRequest)
    }
}
