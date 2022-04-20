//
//  MainVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // MARK: - 변수
    @IBOutlet var studyCollectionView: UICollectionView!
    @IBOutlet var studyNavigationItem: UINavigationItem!
    var rooms = [] as! Array<SearchRoomResponse>
    var roomName: Int?
    var roomNameString: String?
    //var mainTabBarVC : UITabBarController = MainTabBarVC()
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 스터디룸 조회
        self.getSearchRoom()
    }
    
    // 다음 화면 이동전 준비동작 (변수 연결)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "MainDetailVC" {
            if let controller = segue.destination as? MainDetailVC {
                controller.roomName = self.roomName
                controller.roomNameString = self.roomNameString
            }
        }
    }
    
    
    // MARK: - fileprivate func
    fileprivate func config() {
//        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        let width = self.view.frame.width
//        let height = self.view.frame.height
//        flowLayout.itemSize = CGSize(width: width - 20, height: height)
//        self.studyCollectionView.collectionViewLayout = flowLayout
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
//        self.titleItem = TitleItem.titleGeneral(title: "스터디룸", isLargeTitles: true)
        
        // view에 delegate, datasource 연결
        self.studyCollectionView.delegate = self
        self.studyCollectionView.dataSource = self
        
        //  셀 리소스 파일 가져와서 등록하기
        self.studyCollectionView.register(UINib(nibName: "StudyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // 스터디룸 조회
        self.getSearchRoom()
        
        // 스터디룸 추가하라는 라벨을 레이아웃 가운데에 표기
        if rooms.count <= 0 {
            
        }
    }
    
    // 스터디룸 조회 api 호출
    fileprivate func getSearchRoom() {
        AlamofireManager.shared.getSearchRoom(completion: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let roomList):
                self.rooms = roomList
                self.studyCollectionView.reloadData()
            case .failure(let error):
                print("MainVC - getSearchRoom.failure / error: \(error.rawValue)")
            }
        })
    }
}

// MARK: - extension func
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
        let cell = CGSize(width: self.studyCollectionView.bounds.width - 20, height: self.studyCollectionView.bounds.height / 2.05)
//        let cell = CGSize(width: self.studyCollectionView.bounds.width - 100, height: self.studyCollectionView.bounds.height / 6)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("MainVC - collectionView didSelectItemAt / selectedItem : \(rooms[indexPath.row].name) choose")
        //        self.userName = KeyChainManager().tokenLoad(API.SERVICEID, account: "userName")
        self.roomName = rooms[indexPath.row].id
        self.roomNameString = rooms[indexPath.row].name
        self.performSegue(withIdentifier: "MainDetailVC", sender: nil)
    }
}

