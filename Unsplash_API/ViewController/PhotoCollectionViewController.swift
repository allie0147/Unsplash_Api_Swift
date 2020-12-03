//
//  PhotoCollectionViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/29.
//

import UIKit
import SDWebImage

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
        let cellRatio: CGFloat = 1
//        if (UIDevice.current.orientation.isLandscape) {
//            return self.collectionView.getCellSize(numberOfItemsRowAt: 5, cellRatio: cellRatio)
//        } else {
        return self.collectionView.getCellSize(numberOfItemsRowAt: 1.12, cellRatio: cellRatio)
//        }
    }

    // MARK: - CollectionViewDataSource Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedPhoto?.count ?? 0
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        print("CELL: \(indexPath.row)")
        print("fetched cell photo: \(fetchedPhoto?[indexPath.row])")
        // corner radius 설정 !
        cell.layer.cornerRadius = 10
        // image view style
        let transformer = SDImageRoundCornerTransformer(radius: 10, corners: .allCorners, borderWidth: 2, borderColor: UIColor(named: "border"))
        if let item = fetchedPhoto?[indexPath.row] {
            DispatchQueue.main.async {
                cell.lblLikeCount.text = String(item.likeCount)
                cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.large
                cell.imageView.sd_setImage(with: URL(string: item.photoUrl), placeholderImage: nil, context: [.imageTransformer: transformer])
                cell.lblUsername.text = item.username
                // date
                let dates = item.createdAt.components(separatedBy: ["T", "-"])
                cell.lblCreatedAt.text = "\(dates[0])년 \(dates[1])월 \(dates[2])일"
            }
        }
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
