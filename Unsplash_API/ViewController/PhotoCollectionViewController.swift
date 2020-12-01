//
//  PhotoCollectionViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/29.
//

import UIKit

class PhotoCollectionViewController: BaseViewController {

    var fetchedPhoto: [Photo]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PhotoCollectionVC - viewWillApperar()")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("PhotoCollectionVC - viewDidLoad()")
        guard let fetched = fetchedPhoto else {
            return
        }
        print("PhotoCollectionVC - fetched data: \(fetched)")

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
