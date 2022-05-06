//
//  AddStudyMemberVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/22.
//

import Foundation
import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class AddStudyMemberVC : BasicVC, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, MemberCheckButtonDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var registerRoomBtn: UIButton!
    @IBOutlet weak var memberSearchBar: UISearchBar!
    let keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = COLOR.INDICATOR_BACKGROUND_COLOR
        return indicatorView
    }()
    lazy var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                type: .pacman,
                                                color: COLOR.DISABLE_COLOR,
                                                padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    lazy var loading: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "loading..."
        label.textColor = COLOR.DISABLE_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    var members: Array<SearchMemberResponse> = []
    var nextPage: String? = "1"
    var fetchingMore = false
    var studyName: String?
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationBar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "멤버 등록", isLargeTitles: true)
        
        // btn
        self.registerRoomBtn.tintColor = .white
        self.registerRoomBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.registerRoomBtn.layer.cornerRadius = self.registerRoomBtn.bounds.height / 2
        
        // 셀 리소스 파일 가져오기
        let memberCell = UINib(nibName: String(describing: MemberTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        self.memberTableView.register(memberCell, forCellReuseIdentifier: "MemberTableViewCell")
        
        // 셀 설정
        self.memberTableView.rowHeight = 90
//        self.memberTableView.estimatedRowHeight = 100
//        self.memberTableView.mar
        
        // delegate 연결
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
        self.keyboardDismissTabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
        
        // 전체 멤버 조회
        self.getSearchMember()
    }
    
    // 전체 멤버 조회
    fileprivate func getSearchMember() {
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.getSearchMember(page: nextPage ?? "0", completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let response):
                // 다음 페이지 값
                self.nextPage = response["next"].string
                // 1~ 10 멤버 데이터
                let list = response["list"]
                for (index, subJson) : (String, JSON) in list {
                    guard let id = subJson["id"].int
                         ,let username = subJson["username"].string
                         ,let name = subJson["name"].string else { return }
                    let memberItem = SearchMemberResponse(id: id, name: name, userName: username, ischecked: false)
                    self.members.append(memberItem)
                }
                // view reload
                self.memberTableView.reloadData()
            case .failure(let error):
                print("AddStudyMemberVC - getSearchMember.failure / error: \(error.rawValue)")
            }
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // 로딩 그리기
    fileprivate func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: memberTableView.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    fileprivate func onStartActivityIndicator() {
        DispatchQueue.main.async {
            // 불투명 뷰 추가
            self.view.addSubview(self.indicatorView)
            // activity indicator 추가
            self.indicatorView.addSubview(self.indicator)
            self.indicatorView.addSubview(self.loading)
            
            NSLayoutConstraint.activate([
                self.indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.loading.centerYAnchor.constraint(equalTo: self.indicator.bottomAnchor, constant: 5)
            ])
            
            // 애니메이션 시작
            self.indicator.startAnimating()
        }
    }
    
    fileprivate func onStopActivityIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // 애니메이션 정지.
            // 서버 통신 완료 후 다음의 메서드를 실행해서 통신의 끝나는 느낌을 줄 수 있다.
            self.indicator.stopAnimating()
            self.indicatorView.removeFromSuperview()
        }
    }
    
    // MARK: - @IBAction func
    @IBAction func onRegisterRoomBtnClicked(_ sender: Any) {
        var selectedMemeberList: Array<Int> = []
        
        for index in 0..<members.count {
            if members[index].ischecked {
                selectedMemeberList.append(members[index].id)
            }
        }
        
        DispatchQueue.main.async {
                self.onStartActivityIndicator()
        }
        
        AlamofireManager.shared.postRegisterRoom(name: self.studyName!, member_list: selectedMemeberList, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.view.makeToast("스터디룸이 등록되었습니다.", duration: 1.0, position: .center)
                self.performSegue(withIdentifier: "unwindMainTabBarVC", sender: self)
            case .failure(let error):
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 애니메이션 정지.
            // 서버 통신 완료 후 다음의 메서드를 실행해서 통신의 끝나는 느낌을 줄 수 있다.
            self.indicator.stopAnimating()
            self.indicatorView.removeFromSuperview()
        }
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        cell.member.text = members[indexPath.row].name
        cell.memberName.text = members[indexPath.row].userName
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.isChecked = members[indexPath.row].ischecked
        cell.checkBtn.checkBtnDelegate = self
        return cell
    }
    
    func checkBtnClicked(btn: UIButton, ischecked: Bool) {
        print("AddStudyMemberVC - checkBtnClicked() called / btn.tag: \(btn.tag), btn.id: \(members[btn.tag].id) ischecked: \(ischecked)")
        self.members[btn.tag].ischecked = ischecked
    }
    
    // 아래로 스크롤시 event
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // tableView 끝에 도달
        if scrollView.contentOffset.y > (memberTableView.contentSize.height - scrollView.bounds.size.height) {
            // 다음 페이지가 없을 시
            if nextPage != nil {
                // 로딩 가능한지 체크
                if !fetchingMore {
                    // 현재 로딩 On
                    fetchingMore = true
                    
                    // 로딩 생성
                    self.memberTableView.tableFooterView = createSpinnerFooter()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        // 데이터 가져오기
                        self.getSearchMember()
                        
                        // 로딩 off & view reload
                        self.fetchingMore = false
                        self.memberTableView.tableFooterView = nil
                        
                    }
                }
            }
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: memberSearchBar) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
