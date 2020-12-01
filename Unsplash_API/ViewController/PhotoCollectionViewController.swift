//
//  PhotoCollectionViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/29.
//

import UIKit

class PhotoCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var fetchedPhoto: [Photo]?

    @IBOutlet weak var collectionView: UICollectionView!


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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellRatio: CGFloat = 0.45
//        if (UIDevice.current.orientation.isLandscape) {
//            return self.collectionView.getCellSize(numberOfItemsRowAt: 5, cellRatio: cellRatio)
//        } else {
        return self.collectionView.getCellSize(numberOfItemsRowAt: 2.3, cellRatio: cellRatio)
//        }
    }

    // MARK: - CollectionViewDataSource Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
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
// MARK: - Extension
extension UICollectionView {
    func getCellSize(numberOfItemsRowAt: CGFloat, cellRatio: CGFloat) -> CGSize {
        var screenWidth = UIScreen.main.bounds.width
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let leftPadding = window?.safeAreaInsets.left ?? 0
            let rightPadding = window?.safeAreaInsets.right ?? 0
            screenWidth -= (leftPadding + rightPadding)
        }
        let cellWidth = screenWidth / numberOfItemsRowAt
        let cellHeight = screenWidth * cellRatio
        print("screenWidth: \(screenWidth), cellWidth: \(cellWidth), cellRatio: \(cellRatio), cellHeight: \(cellHeight)")
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
