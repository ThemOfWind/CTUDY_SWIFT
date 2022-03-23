//
//  AddStudyMemberVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/22.
//

import Foundation
import UIKit

class AddStudyMemberVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MemberTableView: UITableView!
    
    var members : Array<SearchMemberResponse> = []
    var studyName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀 리소스 파일 가져오기
        let memberCell = UINib(nibName: String(describing: MemberTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        self.MemberTableView.register(memberCell, forCellReuseIdentifier: "MemberTableViewCell")
        
        // 셀 설정
        self.MemberTableView.rowHeight = UITableView.automaticDimension
        self.MemberTableView.estimatedRowHeight = 50
        
        // delegate 연결
        self.MemberTableView.delegate = self
        self.MemberTableView.dataSource = self
        
        // 전체 멤버 조회
        getSearchMember()
        //print("members: \(members)")
    }
    
    fileprivate func getSearchMember() {
        AlamofireManager.shared.getSearchMember(competion: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let memberList):
                self.members = memberList
                self.MemberTableView.reloadData()
            case .failure(let error):
                print("AddStudyMemberVC - getSearchMember.failure / error: \(error)")
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MemberTableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        cell.memberName.text = members[indexPath.row].userName
        return cell
    }
}
