//
//  BaseViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/30.
//

import UIKit

class BaseViewController: UIViewController {

    var vcTitle: String = "" {
        //
        didSet {
            print("userListVC - vcTitle didSet() called / vcTitle: \(vcTitle)")
            self.title = vcTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
