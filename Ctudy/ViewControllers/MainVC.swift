//
//  MainVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    @IBOutlet var studyCollectionView: UICollectionView!
    @IBOutlet var studyNavigationItem: UINavigationItem!
    var rooms = [] as! Array<SearchRoomResponse>
    //var mainTabBarVC : UITabBarController = MainTabBarVC()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    fileprivate func config() {
        // View에 delegate, datasource 연결
        self.studyCollectionView.delegate = self
        self.studyCollectionView.dataSource = self
        
        //  셀 리소스 파일 가져와서 등록하기
        self.studyCollectionView.register(UINib(nibName: "StudyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // 스터디룸 조회
        getSearchRoom()
        
        // 스터디룸 추가 셀
        //        var testList = [SearchRoomResponse(name: "바람의 녀석들", membercount: 4, mastername: "김밍구")]
        //        testList.append(contentsOf: [SearchRoomResponse(name: "", membercount: 2, mastername: "김지니")])
        //        self.rooms = testList
    }
    
    fileprivate func getSearchRoom() {
        AlamofireManager.shared.getSearchRoom(completion: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let roomList):
                self.rooms = roomList
                self.studyCollectionView.reloadData()
            case .failure(let error):
                print("MainVC - getSearchRoom.failure / error: \(error)")
            }
        })
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("MainVC - collectionView count : \(rooms.count)")
        // 셀의 갯수 지정
        return rooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("MainVC - collectionView cellForItemAt / indexPath : \(indexPath.row)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StudyCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.roomName.text = rooms[indexPath.row].name
        cell.roomMembers.text = String(describing: rooms[indexPath.row].membercount)
        cell.roomMasterName.text = rooms[indexPath.row].mastername
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = CGSize(width: self.studyCollectionView.bounds.width - 100, height: self.studyCollectionView.bounds.height / 6)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("MainVC - collectionView didSelectItemAt / selectedItem : \(rooms[indexPath.row].name) choose")
        
        self.performSegue(withIdentifier: "MainDetailVC", sender: nil)
    }
}

