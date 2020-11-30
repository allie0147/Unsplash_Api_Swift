//
//  ViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/29.
//

import UIKit
import Toast_Swift

class HomeViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!

    var keyboardDismissTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeVC - viewDidLoad() called")
        self.viewConfig()
    }

    //MARK: - fileprivate methods
    fileprivate func viewConfig() {
        // ui 설정
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.becomeFirstResponder()
        // delegate 설정
        self.searchBar.delegate = self
        self.keyboardDismissTapGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }

    fileprivate func pushVC() {
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
        pushVC() // 화면 이동
    }

    // MARK: - UISearchBar Delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked()")

        guard let userInputString = searchBar.text else { return }
        if userInputString.isEmpty { self.view.makeToast("검색 키워드를 입력하세요🤓", duration: 1.0, position: .center) }
        else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() / searchText : \(searchText)")
        // 입력 값이 없을 때
        if (searchText.isEmpty) {
            self.searchButton.isHidden = true
            // x 버튼을 눌렀을 때 resign이 적용되지 않아 GCD 사용
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    searchBar.resignFirstResponder()
                })
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
            self.view.makeToast("12자까지 입력 가능합니다😕", duration: 1.0, position: .center)
            return false
        }
        return true
    }

    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HomeVC - gestureRecognizer shouldReceive")
        // 터치로 들어온 뷰 판단
        if (touch.view?.isDescendant(of: searchFilterSegment) == true || touch.view?.isDescendant(of: searchBar) == true) {
            return false
        } else {
            view.endEditing(true) // true: force resign
            return true
        }
    }
}

