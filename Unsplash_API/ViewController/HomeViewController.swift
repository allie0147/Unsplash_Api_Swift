//
//  ViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/29.
//

import UIKit
import Toast_Swift

class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeVC - viewDidLoad() called")
        // ui 설정
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        // delegate 설정
        self.searchBar.delegate = self
    }

    // MARK: - IBAction methods
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        print("HomeVC - searchFilterValueChanged() called")
        var searchBarTitle = ""
        switch sender.selectedSegmentIndex {
        case 0: // 왼쪽
            searchBarTitle = "사진 키워드"
        case 1: // 오른쪽
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        self.searchBar.placeholder = searchBarTitle + " 입력"
        // first responder로 지정하여 view에서 첫번째로 event를 수행하도록 함
        // searchBar에서는 키보드 포커싱 이벤트
        self.searchBar.becomeFirstResponder()
//      #  self.searchBar.resignFirstResponder() : first responder 해제
    }

    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() called / segment index :\(searchFilterSegment.selectedSegmentIndex)")
        var segueId = ""
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            segueId = "goToPhotoCollection"
        case 1:
            segueId = "goToUserList"
        default:
            segueId = "goToPhotoCollection"
        }
        // 화면이동
        self.performSegue(withIdentifier: segueId, sender: self) // home vc에서 보내는 segue
    }

    // MARK: - UISearchBar Delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() / searchText : \(searchText)")
        // 입력 값이 없을 때
        if (searchText.isEmpty) {
            self.searchButton.isHidden = true
            searchBar.resignFirstResponder()
        } else {
            self.searchButton.isHidden = false
        }
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("HomeVC - searchBar shouldChangeTextIn() / range : \(range)") // range : {x축(int), y축(int)}
//        let textCount = searchBar.text?.appending(text).count ?? 0 // Optional(int)
//        print("HomeVC - searchBar shouldChangeTextIn() / text : \(textCount)") // text.length()
        // 12자 이상일 경우
        guard let textCount = searchBar.text?.appending(text).count, textCount <= 12 else {
            self.view.makeToast("12자까지 입력 가능합니다😕", duration: 3.0, position: .center)
            return false
        }
        return true
    }
}

