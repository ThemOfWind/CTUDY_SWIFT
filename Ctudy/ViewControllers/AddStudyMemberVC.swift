//
//  AddStudyMemberVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/22.
//

import Foundation
import UIKit
import SwiftyJSON

class AddStudyMemberVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var registerStudyBtn: UIButton!
    
    var members : Array<SearchMemberResponse> = []
    var nextPage : String? = "1"
    var fetchingMore = false //
    var studyName : String?
    
    // MARK: - overrid & filepriavte methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.config()
    }
    
    fileprivate func config() {
        //UI
        self.registerStudyBtn.layer.cornerRadius = 30
        self.registerStudyBtn.layer.borderWidth = 1
        self.registerStudyBtn.layer.borderColor = UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1).cgColor
        
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
        getSearchMember()
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
                    
                    let memberItem = SearchMemberResponse(id: id, userName: username)
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
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        cell.memberName.text = members[indexPath.row].userName
        cell.checkBtn.tag = indexPath.row
        return cell
    }
    
    // btn click event delegate
//    func seletedInfoBtn(btn: UIButton, index: Int, chekced checked: Bool) {
//
//    }
    
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
