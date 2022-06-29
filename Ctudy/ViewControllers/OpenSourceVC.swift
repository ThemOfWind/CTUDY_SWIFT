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
    // 셋팅 항목
    let settingList = [
        [ "id" : 0, "text" : "Alamofire", "color" : UIColor.black, "url" : "https://github.com/Alamofire/Alamofire" ]
        , [ "id" : 1, "text" : "AlamofireNetworkActivityIndicator", "color" : UIColor.black, "url" : "https://github.com/Alamofire/AlamofireNetworkActivityIndicator" ]
        , [ "id" : 2, "text" : "Kingfisher", "color" : UIColor.black, "url" : "https://github.com/onevcat/Kingfisher" ]
        , [ "id" : 3, "text" : "NVActivityIndicatorView", "color" : UIColor.black, "url" : "https://github.com/ninjaprox/NVActivityIndicatorView" ]
        , [ "id" : 4, "text" : "SwiftyJSON", "color" : UIColor.black, "url" : "https://github.com/SwiftyJSON/SwiftyJSON" ]
        , [ "id" : 5, "text" : "Toast-Swift", "color" : UIColor.black, "url" : "https://github.com/scalessec/Toast-Swift" ]
    ]
    var url: URL!
    var titleText: String!
    
    // MARK: - view load func
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationController?.navigationBar.sizeToFit() // UIKit에 포함된 특정 View를 자체 내부 요구의 사이즈로 resize 해주는 함수
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "오픈소스 라이센스 이용고지", isLargeTitles: false)
        
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
        cell.settingLabel.text = settingList[(indexPath as NSIndexPath).row]["text"] as! String
        cell.settingLabel.textColor = settingList[(indexPath as NSIndexPath).row]["color"] as! UIColor
        cell.settingLabel.font = UIFont.systemFont(ofSize: CGFloat(15.0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        url = URL(string: settingList[(indexPath as NSIndexPath).row]["url"] as! String)
        titleText = settingList[(indexPath as NSIndexPath).row]["text"] as! String
        self.performSegue(withIdentifier: "OpenSourceWebVC", sender: self)
    }
}
