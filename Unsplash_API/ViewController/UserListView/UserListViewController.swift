//
//  UserListVCViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/29.
//

import UIKit
import SDWebImage

class UserListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var fetchedUser: [User]?

    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // delegeate
        tableView.delegate = self
        tableView.dataSource = self
        // xib 설정
        let nibName = UINib(nibName: "UserListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "userCell")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! WebKitViewController
        nextVC.uId = username
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let query = fetchedUser?[indexPath.row].username else { return }
        self.username = query
        performSegue(withIdentifier: SEGUE_ID.WEB_KIT_VC_USER, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedUser?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserListTableViewCell
        let transformer = SDImageRoundCornerTransformer(radius: 50, corners: .allCorners, borderWidth: 1, borderColor: UIColor(named: "border"))
        if let item = fetchedUser?[indexPath.row] {
            cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            cell.profileImageView.sd_setImage(with: URL(string: item.profileImage), placeholderImage: nil, options: [.scaleDownLargeImages, .refreshCached], context: [.imageTransformer: transformer])
            cell.lblLikes.text = String(item.totalLikes)
            cell.lblName.text = item.name
            cell.lblUsername.text = item.username
            cell.lblPhotos.text = String(item.totalPhotos)
            self.sizeFits(cell)
        }
        return cell
    }

    func sizeFits(_ cell: UserListTableViewCell) {
        cell.lblPhotos.sizeToFit()
        cell.lblUsername.sizeToFit()
        cell.lblLikes.sizeToFit()
        cell.lblName.sizeToFit()
    }
}
