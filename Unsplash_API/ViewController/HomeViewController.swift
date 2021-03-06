//
//  ViewController.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/11/29.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeViewController: BaseViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!

    var keyboardDismissTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)

    var photoData: [Photo]?

    var userData: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeVC - viewDidLoad() called")
        self.viewConfig()
    }

    func searchButtonEnabled() { // 버튼 사용 가능
        self.searchButton.isUserInteractionEnabled = true
        self.searchButton.isHidden = false
        self.searchButton.setTitle("검색", for: .normal)
        self.searchIndicator.isHidden = true
    }

    func searchButtonDisabled() { // 버튼 사용 불가능
        self.searchButton.isUserInteractionEnabled = false
        self.searchButton.isHidden = false
        self.searchButton.setTitle("", for: .normal)
        self.searchIndicator.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() called")
        self.searchButton.isUserInteractionEnabled = true
        self.searchIndicator.isHidden = true
        self.searchButton.setTitle("검색", for: .normal)
        // keyboard noti를 등록한다
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisapper()")
        // keyboard noti를 해제한다
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 화면이 넘어가기 전에 준비한다 == pushVC()의 performSegue 이후에 진행된다
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() called / segue.identifier : \(segue.identifier)") // Optional
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면의 뷰 컨트롤러를 가져온다
            let nextVC = segue.destination as! UserListViewController
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + " 👀"
            nextVC.fetchedUser = userData
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionViewController
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + " 🌌"
            nextVC.fetchedPhoto = photoData
        default: break
        }
    }

    //MARK: - fileprivate methods
    fileprivate func viewConfig() {
        // ui 설정
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        // delegate 설정
        self.searchBar.delegate = self
        self.keyboardDismissTapGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }

    fileprivate func pushVC() { // before prepare() called
        print("HomeVC - pushVC() called")
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

    // MARK: - @objc methods
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillShowHandle() called")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if (searchButton.frame.origin.y > keyboardSize.height) {
                // 키보드가 버튼을 덮는 경우, 버튼이 적용된 길이 - 키보드 길이 만큼 화면을 올려준다
                // 값은 마이너스여야 올라가기 때문에 키보드 길이에서 버튼이 적용된 길이를 뺀다
                self.view.frame.origin.y = keyboardSize.height - (searchButton.frame.origin.y)
            }
        }
    }

    @objc func keyboardWillHideHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillHideHandle() called")
        self.view.frame.origin.y = 0
    }

    // MARK: - IBAction methods
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() called / segment index :\(searchFilterSegment.selectedSegmentIndex)")
//        let url = API.BASE_URL + "search/photos"
        searchButtonDisabled()
        guard let userInput = self.searchBar.text else { return }
//        let queryParam = ["client_id": API.CLIENT_ID, "query": userInput]
//        AF.request(url, method: .get, parameters: queryParam).responseJSON { response in
//            debugPrint(response)
//        }
//        var urlToCall: URLRequestConvertible?
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
//            urlToCall = MySearchRouter.searchPhotos(term: userInput)
            MyAlamofireManager.shared.getPhotos(searchTerm: userInput,
                completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let fetchedPhotos):
                        print("HomeVC - getPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                        self.photoData = fetchedPhotos // 값 있음 둘다
                        self.pushVC() // 데이터를 다 받아 온 후에 pushVC()를 불러 segue를 실행시킨다
                    case .failure(let error):
                        print("HomeVc - getPhotos.failure - error : \(error.rawValue)")
                        self.searchButtonEnabled()
                        self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                    }
                })
        case 1:
//            urlToCall = MySearchRouter.searchUsers(term: userInput)
            MyAlamofireManager.shared.getUsers(searchTerm: userInput, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let fetchedUsers):
                    print("HomeVC - getUsers.success - fetchedUsers.count : \(fetchedUsers.count)")
                    self.userData = fetchedUsers
                    self.pushVC()
                case .failure(let error):
                    print("HomeVC - getUsers.failure - error : \(error.rawValue)")
                    self.searchButtonEnabled()
                    self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                }
            })
        default:
            print("default")
        }
//        if let urlConvertible = urlToCall {
//            MyAlamofireManager
//                .shared
//                .session
//                .request(urlConvertible)
//                .validate(statusCode: 200..<401)
//                .responseJSON(completionHandler: { response in
//                    debugPrint(response)
//                }) }
//        pushVC() // 화면 이동
    }

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

    // MARK: - UISearchBar Delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked()")
        guard let userInputString = searchBar.text else { return }
        if userInputString.isEmpty {
            searchButtonEnabled()
            self.view.makeToast("검색 키워드를 입력하세요🤓", duration: 1.0, position: .center) }
        else {
            onSearchButtonClicked(searchButton)
            searchButtonDisabled()
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() / searchText : \(searchText)")
        // 입력 값이 없을 때
        if (searchText.isEmpty) {
            self.searchButton.isHidden = true
            // x 버튼을 눌렀을 때 resign이 적용되지 않아 GCD 사용
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
//                    searchBar.resignFirstResponder()
//                })
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

