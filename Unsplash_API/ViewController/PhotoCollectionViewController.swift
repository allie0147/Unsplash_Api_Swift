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
        let cellRatio: CGFloat = 1.05
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
//        cell.imageView.layer.borderWidth = 1.5
//        cell.imageView.layer.borderColor = UIColor.black.cgColor
        // 두 레이어 겹치는 부분 border 하나 제거 !
        // corner radius 설정 !

        if let item = fetchedPhoto?[indexPath.row] {
            DispatchQueue.main.async {
                cell.lblLikeCount.text = item.likeCount.description.trimmingCharacters(in: .whitespacesAndNewlines)
                cell.lblCreatedAt.text = item.createdAt.description.trimmingCharacters(in: .whitespacesAndNewlines)
                //             item.thumbnail
//                cell.imageView.sd_setImage(with: item.thumbnail, placeholder: nil)
                
                cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let transformer = SDImageRoundCornerTransformer(radius: 10, corners: .allCorners, borderWidth: 1.5, borderColor: UIColor.black)
                cell.imageView.sd_setImage(with: URL(string: item.photoUrl), placeholderImage: nil, context: [.imageTransformer: transformer])
//                let manager = SDWebImageManager.shared.loadImage(with: URL(string: item.photoUrl), options: SDWebImageOptions, progress: nil, completed: {_,_,_,_,_,_ in
//
//                    
//
//                })
//                let corners = [SDRectCorner.topLeft, SDRectCorner.topRight]
//                cell.imageView.sd_imageIndicator = SDWebImageProgressIndicator.`default`
                cell.lblUsername.text = item.username.description.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        //        Optional(Unsplash_API.Photo(thumbnail: "https://images.unsplash.com/photo-1543458113-18eaab9bcd3f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxODY4MTV8MHwxfHNlYXJjaHwxfHx8ZW58MHx8fA&ixlib=rb-1.2.1&q=80&w=200", username: "jcdilorenzo", likeCount: 49, createdAt: "2018-11-28T21:28:03-05:00"))
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
