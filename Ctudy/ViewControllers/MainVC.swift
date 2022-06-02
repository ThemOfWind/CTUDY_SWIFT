//
//  MainVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - 변수
    @IBOutlet var studyCollectionView: UICollectionView!
    var rooms = [] as! Array<SearchRoomResponse>
    var roomId: Int?
    var roomName: String?
    
    // MARK: - overrid func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.config()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.rooms.removeAll()
        super.viewDidDisappear(animated)
    }

    
    // 다음 화면 이동전 준비동작 (변수 연결)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "MainDetailVC" {
            if let controller = segue.destination as? MainDetailVC {
                controller.roomId = self.roomId
                controller.roomName = self.roomName
            }
        }
//        } else if let id = segue.identifier, id == "AddStudyNameVC" {
//            if let controller = segue.destination as? AddStudyNameVC {
//            }
//        }
    }
    
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // 스터디룸 조회
        self.getSearchRoom()
        
        // view에 delegate, datasource 연결
        self.studyCollectionView.delegate = self
        self.studyCollectionView.dataSource = self
        
        //  셀 리소스 파일 가져와서 등록하기
        self.studyCollectionView.register(UINib(nibName: "StudyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.studyCollectionView.showsVerticalScrollIndicator = false // scroll 제거
        self.studyCollectionView.clearsContextBeforeDrawing = true
    }
    
    // 스터디룸 조회 api 호출
    fileprivate func getSearchRoom() {
        self.rooms.removeAll()
        
        AlamofireManager.shared.getSearchRoom(completion: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let roomList):
//                self.rooms = self.reloadDataWithDiff(newData: roomList, prevData: self.rooms)
                self.rooms = roomList
                self.studyCollectionView.reloadData()
//                self.studyCollectionView.reloadData()
            case .failure(let error):
                print("MainVC - getSearchRoom.failure / error: \(error.rawValue)")
            }
        })
    }
    
//    fileprivate func reloadDataWithDiff(newData: [SearchRoomResponse], prevData: [SearchRoomResponse]) -> [SearchRoomResponse] {
//        let diff = newData.difference(from: prevData, by: )
//    }
    
    // MARK: - collectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print("MainVC - collectionView count : \(rooms.count)")
        // 셀의 갯수 지정
        return rooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("MainVC - collectionView cellForItemAt / indexPath : \(indexPath.row)")
        print("MainVC - collectionView cellForItemAt / roomName : \(rooms[indexPath.row].name)")
        print("MainVC - collectionView cellForItemAt / banner : \(rooms[indexPath.row].banner)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StudyCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.roomName.text = rooms[indexPath.row].name
        cell.roomMembers.text = String(describing: rooms[indexPath.row].membercount)
        cell.roomMasterName.text = rooms[indexPath.row].mastername
//        cell.roomImg.imageLoad(urlString: "https://api.ctudy.com\(rooms[indexPath.row].banner)", size: cell.roomImg.image!.size)
        if rooms[indexPath.row].banner != "" {
            cell.roomImg.kf.setImage(with: URL(string: API.IMAGE_URL + rooms[indexPath.row].banner)!)
        } else {
            cell.roomImg.image = UIImage(named: "studyroom_default.png")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let cell = CGSize(width: self.studyCollectionView.layer.bounds.width, height: self.studyCollectionView.layer.bounds.height / 1.7)
        let cell = CGSize(width: self.studyCollectionView.layer.bounds.width, height: 260)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("MainVC - collectionView didSelectItemAt / selectedItem : \(rooms[indexPath.row].name) choose")
        self.roomId = rooms[indexPath.row].id
        self.roomName = rooms[indexPath.row].name
        self.performSegue(withIdentifier: "MainDetailVC", sender: nil)
    }
}

//extension UIImageView {
//    func load(url: URL, size: CGSize) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image.resize(size: size, scale: UIScreen.main.scale)
//                    }
//                }
//            } else {
//                if let data = try? Data(contentsOf: URL(string: API.IMAGE_DEFAULT_URL)!) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self?.image = image.resize(size: size, scale: UIScreen.main.scale)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
