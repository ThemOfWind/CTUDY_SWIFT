//
//  NoticeVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/17.
//

import Foundation
import UIKit

class OpenSourceVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
    @IBOutlet weak var osTableView: UITableView!
    var settingList: Array<SettingModel> = [] // 셋팅 항목
    var url: URL!
    var titleText: String!
    
    // MARK: - view load func
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        config()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "OpenSourceWebVC" {
            if let controller = segue.destination as? OpenSourceWebVC {
                controller.url = url
                controller.titleText = titleText
            }
        }
    }
    
    fileprivate func config() {
        // navigationbar
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "오픈소스 라이센스 이용고지", isLargeTitles: false)
        
        // list 담기 (url 대신 page로 사용)
        let item1 = SettingModel(id: "Alamofire", text: "Alamofire", color: "black", page: "https://github.com/Alamofire/Alamofire")
        let item2 = SettingModel(id: "AlamofireIndicator", text: "AlamofireNetworkActivityIndicator", color: "black", page: "https://github.com/Alamofire/AlamofireNetworkActivityIndicator")
        let item3 = SettingModel(id: "Kingfisher", text: "Kingfisher", color: "black", page: "https://github.com/onevcat/Kingfisher")
        let item4 = SettingModel(id: "NVActIndicator", text: "NVActivityIndicatorView", color: "black", page: "https://github.com/ninjaprox/NVActivityIndicatorView")
        let item5 = SettingModel(id: "SwiftyJSON", text: "SwiftyJSON", color: "black", page: "https://github.com/SwiftyJSON/SwiftyJSON")
        let item6 = SettingModel(id: "ToastSwift", text: "Toast-Swift", color: "black", page: "https://github.com/scalessec/Toast-Swift")
        settingList.append(item1)
        settingList.append(item2)
        settingList.append(item3)
        settingList.append(item4)
        settingList.append(item5)
        settingList.append(item6)
        
        // 셀 리소스 파일 가져오기
        let settingCell = UINib(nibName: String(describing: SettingTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        self.osTableView.register(settingCell, forCellReuseIdentifier: "SettingTableViewCell")
        
        // 셀 설정
        self.osTableView.rowHeight = 50
        //        self.settingTableView.allowsSelection = true
        self.osTableView.showsVerticalScrollIndicator = false // scroll 제거
        
        // delegate 연결
        self.osTableView.delegate = self
        self.osTableView.dataSource = self
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = osTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none // 선택 block 없애기
        cell.settingLabel.text = settingList[indexPath.row].text
        cell.settingLabel.textColor = UIColor(named: settingList[indexPath.row].color)
        cell.settingLabel.font = UIFont.systemFont(ofSize: CGFloat(15.0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        url = URL(string: settingList[indexPath.row].page)
        titleText = settingList[indexPath.row].text
        self.performSegue(withIdentifier: "OpenSourceWebVC", sender: self)
    }
}
