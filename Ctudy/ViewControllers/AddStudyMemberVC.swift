//
//  AddStudyMemberVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/22.
//

import Foundation
import UIKit
import SwiftyJSON

class AddStudyMemberVC : BasicVC, UITableViewDelegate, UITableViewDataSource, MemberCheckButtonDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var registerStudyBtn: UIButton!
    @IBOutlet weak var memberSearchBar: UITableView!
    var members : Array<SearchMemberResponse> = []
    var nextPage : String? = "1"
    var fetchingMore = false
    var studyName : String?
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationBar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "스터디멤버 등록")
        self.rightItem = RightItem.none
        
        // btn
        self.registerStudyBtn.layer.cornerRadius = 30
        self.registerStudyBtn.layer.borderWidth = 1
        self.registerStudyBtn.layer.borderColor = COLOR.DISABLE_COLORL.cgColor
        self.registerStudyBtn.isEnabled = false
        
        // 셀 리소스 파일 가져오기
        let memberCell = UINib(nibName: String(describing: MemberTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        self.memberTableView.register(memberCell, forCellReuseIdentifier: "MemberTableViewCell")
        
        // 셀 설정
        self.memberTableView.rowHeight = UITableView.automaticDimension
        self.memberTableView.estimatedRowHeight = 50
//        self.memberTableView.mar
        
        // delegate 연결
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
        
        // 전체 멤버 조회
        self.getSearchMember()
    }
    
    // 전체 멤버 조회
    fileprivate func getSearchMember() {
        AlamofireManager.shared.getSearchMember(page: nextPage ?? "0", competion: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // 다음 페이지 값
                self.nextPage = response["next"].string
                // 1~ 10 멤버 데이터
                let list = response["list"]
                for (index, subJson) : (String, JSON) in list {
                    guard let id = subJson["id"].int
                            ,let username = subJson["username"].string
                    else { return }
                    
                    let memberItem = SearchMemberResponse(id: id, userName: username, ischecked: false)
                    self.members.append(memberItem)
                }
                // view reload
                self.memberTableView.reloadData()
            case .failure(let error):
                print("AddStudyMemberVC - getSearchMember.failure / error: \(error)")
            }
        })
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
    
    // ischecked 값에 따라 registerStudyBtn enable event
    fileprivate func editingChange() {
        // ischecked true 확인
        for index in 0..<members.count {
            if members[index].ischecked {
                self.registerStudyBtn.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
                self.registerStudyBtn.isEnabled = true
                return
            }
        }
        
        self.registerStudyBtn.layer.borderColor = COLOR.DISABLE_COLORL.cgColor
        self.registerStudyBtn.isEnabled = false
    }
    
    // MARK: - delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        cell.memberName.text = members[indexPath.row].userName
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.isChecked = members[indexPath.row].ischecked
        cell.checkBtn.checkBtnDelegate = self
        return cell
    }
    
    func checkBtnClicked(btn: UIButton, ischecked: Bool) {
        print("AddStudyMemberVC - checkBtnClicked() called / btn.tag: \(btn.tag), ischecked: \(ischecked)")
        self.members[btn.tag].ischecked = ischecked
        
        // registerStudyBtn enable event
        editingChange()
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
}
