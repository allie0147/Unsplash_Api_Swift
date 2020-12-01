//
//  BaseViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {

    var vcTitle: String = "" {

        didSet {
            print("BaseVC - vcTitle didSet() called / vcTitle: \(vcTitle)")
            self.title = vcTitle
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // api key 인증 실패 noti를 등록한다
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notification:)), name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil)
    }

//    MARK: - Objc methods
    @objc func showErrorPopup(notification: NSNotification) {
        print("BaseVC - showErrorPopup() called")
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopup() data : \(data)")
            // ui와 관련된 기능은 Main thread에서 실행한다
            DispatchQueue.main.async {
                self.view.makeToast("🚫 \(data) 에러입니다", duration: 1.0, position: .center)
            }
        }
    }
}
