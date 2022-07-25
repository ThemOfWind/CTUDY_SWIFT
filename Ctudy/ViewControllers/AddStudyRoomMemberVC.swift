//
//  AddStudyRoomMemberVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/18.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class AddStudyRoomMemberVC: BasicVC, UITableViewDelegate, UITableViewDataSource, MemberCheckButtonDelegate, UITextFieldDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var invitationBtn: UIButton!
    @IBOutlet weak var memberSearchBar: UISearchBar!
    @IBOutlet weak var memberTableView: UITableView!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: AddStudyRoomMemberVC.self, action: nil)
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = UIColor.white
        return indicatorView
    }()
    lazy var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                type: .pacman,
                                                color: COLOR.SIGNATURE_COLOR,
                                                padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    lazy var loading: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "loading..."
        label.textColor = COLOR.SIGNATURE_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var members: Array<SearchMemberResponse> = []
    var roomId: Int! // 전달받은 roomId
    var nextPage: String? = "1"
    var fetchingMore = false
    
    // MARK: - view load func
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    fileprivate func config() {
        // navigationbar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "멤버 초대", isLargeTitles: true)
        
        // button
        invitationBtn.tintColor = .white
        invitationBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        invitationBtn.layer.cornerRadius = 10
        
        // 셀 리소스 파일 가져오기
        let memberCell = UINib(nibName: String(describing: MemberTableViewCell.self), bundle: nil)
        let emptyCell = EmptyTableViewCell.nib()
        
        // 셀 리소스 등록하기
        memberTableView.register(memberCell, forCellReuseIdentifier: "MemberTableViewCell")
        memberTableView.register(emptyCell, forCellReuseIdentifier: "EmptyTableViewCell")
        
        // 셀 설정
        memberTableView.rowHeight = 90
        memberTableView.showsVerticalScrollIndicator = false // scroll 제거
        
        // button event 연결
        invitationBtn.addTarget(self, action: #selector(onInvitationBtnClicked), for: .touchUpInside)
        memberSearchBar.searchTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        // delegate 연결
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberSearchBar.searchTextField.delegate = self
        tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
        
        // 전체 멤버 조회
        getSearchMember(text: memberSearchBar.searchTextField.text ?? "")
    }
    
    // MARK: - search member api
    // 전체 멤버 조회
    fileprivate func getSearchMember(text: String) {
        AlamofireManager.shared.getSearchMember(search: text, roomId: String(roomId), page: nextPage ?? "0", completion: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // 다음 페이지 값
                self.nextPage = response["next"].string
                
                // 1~ 10 멤버 데이터
                let list = response["items"]
                for (_, subJson) : (String, JSON) in list {
                    guard let id = subJson["id"].int
                            , let username = subJson["username"].string
                            , let name = subJson["name"].string else { return }
                    let image = subJson["image"].string ?? ""
                    let memberItem = SearchMemberResponse(id: id, name: name, userName: username, image: image, ischecked: false)
                    self.members.append(memberItem)
                }
                // view reload
                self.memberTableView.reloadData()
            case .failure(let error):
                print("AddStudyRoomMemberVC - getSearchMember.failure / error: \(error.rawValue)")
            }
        })
    }
    
    // MARK: - invitation api
    @objc fileprivate func onInvitationBtnClicked() {
        var selectedMemeberList: Array<Int> = []
        
        for index in 0..<members.count {
            if members[index].ischecked {
                selectedMemeberList.append(members[index].id)
            }
        }
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.postInviteMember(id: String(roomId), memberList: selectedMemeberList, completion:  { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: "unwindMainDetailVC", sender: self)
                self.navigationController?.view.makeToast("멤버가 초대되었습니다.", duration: 1.0, position: .center)
            case .failure(let error):
                print("RegisterStudyRoomSecondVC - postRegisterRoom() called / error: \(error.rawValue)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - indicator in api calling
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
    
    // MARK: - infinity scroll
    // 로딩 그리기
    fileprivate func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: memberTableView.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
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
                        self.getSearchMember(text: self.memberSearchBar.searchTextField.text ?? "")
                        
                        // 로딩 off & view reload
                        self.fetchingMore = false
                        self.memberTableView.tableFooterView = nil
                    }
                }
            }
        }
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if members.count == 0 {
            return 1
        } else {
            return members.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if members.isEmpty == true {
            let cell = memberTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "초대할 멤버가 없습니다.🥲"
            memberTableView.rowHeight = self.memberTableView.bounds.height
            return cell
        } else {
            let cell = memberTableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
            cell.selectionStyle = .none // 선택 block 없애기
            if members[indexPath.row].image != "" {
                cell.memberImg.kf.indicatorType = .activity
                cell.memberImg.kf.setImage(with: URL(string: API.IMAGE_URL + members[indexPath.row].image)!)
            } else {
                cell.memberImg.image = UIImage(named: "user_default.png")
            }
            cell.member.text = members[indexPath.row].name
            cell.memberName.text = "@\(members[indexPath.row].userName)"
            cell.checkBtn.tag = indexPath.row
            cell.checkBtn.isChecked = members[indexPath.row].ischecked
            cell.checkBtn.checkBtnDelegate = self
            memberTableView.rowHeight = 90
            return cell
        }
    }
    
    // custom button event
    func checkBtnClicked(btn: UIButton, ischecked: Bool) {
        print("AddStudyRoomMemberVC - checkBtnClicked() called / btn.tag: \(btn.tag), btn.id: \(members[btn.tag].id) ischecked: \(ischecked)")
        self.members[btn.tag].ischecked = ischecked
    }
    
    // MARK: - textfield delegate
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        getSearchMember(text: textField.text ?? "")
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
