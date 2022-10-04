//
//  SignUpFirstVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/30.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class SignUpFirstVC: BasicVC, AgreementCheckButtonDelegate, GoToViewButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
    @IBOutlet weak var agreementTableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var goToStartBtn: UIButton!
    var agreementList: Array<AgreementModel> = []
    
    // MARK: - view load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.config()
    }
    
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.titleGeneral(title: "회원가입", isLargeTitles: true)
        
        // list 담기
        let privacy = AgreementModel(id: "privacy", text: "[필수] 개인정보 처리 방침에 동의합니다.", page: "PrivacyVC", isChecked: false)
        let service = AgreementModel(id: "service", text: "[필수] 이용약관에 동의합니다.", page: "ServiceVC", isChecked: false)
        agreementList.append(privacy)
        agreementList.append(service)
        
        // button ui
        nextBtn.tintColor = .white
        nextBtn.layer.cornerRadius = 10
        nextBtnAbleChecked()
        
        // 셀 리소스 파일 가져오기
        let agreementCell = UINib(nibName: String(describing: AgreementTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        agreementTableView.register(agreementCell, forCellReuseIdentifier: "AgreementTableViewCell")
        
        // 셀 설정
        agreementTableView.rowHeight = 70
        agreementTableView.showsVerticalScrollIndicator = false // scroll 제거
        
        // delegete
        agreementTableView.delegate = self
        agreementTableView.dataSource = self
        
        // button event 연결
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
    }
    
    // nextButton 활성화 & 비활성화 event
    fileprivate func nextBtnAbleChecked() {
        if  agreementList[0].isChecked && agreementList[1].isChecked{
            self.nextBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.nextBtn.isEnabled = true
        } else {
            self.nextBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.nextBtn.isEnabled = false
        }
    }
    
    // MARK: - go to startview func
    @objc fileprivate func onGoToStartBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agreementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgreementTableViewCell", for: indexPath) as! AgreementTableViewCell
        cell.selectionStyle = .none // 선택 block 없애기
        cell.agreementLabel.text = agreementList[indexPath.row].text
        cell.agreementCheckBtn.tag = indexPath.row
        cell.agreementCheckBtn.isChecked = agreementList[indexPath.row].isChecked
        cell.agreementCheckBtn.checkBtnDelegate = self
        cell.goToViewBtn.tag = indexPath.row
        cell.goToViewBtn.nextBtnDelegate = self
        return cell
    }
    
    // MARK: - agreementCheckButton delegate
    func agreementCheckBtnClicked(sender: UIButton, ischecked: Bool) {
        self.agreementList[sender.tag].isChecked = ischecked
        nextBtnAbleChecked()
    }
    
    // MARK: - goToViewButton delegate
    func goToViewBtnClicked(sender: UIButton) {
        print("sender.tag: \(sender.tag), page: \(agreementList[sender.tag].page)")
//        self.performSegue(withIdentifier: agreementList[sender.tag].page, sender: self)
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: agreementList[sender.tag].page)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}
