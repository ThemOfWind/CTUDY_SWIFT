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
import NVActivityIndicatorView

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    // MARK: - 변수
    @IBOutlet var studyCollectionView: UICollectionView!
    var rooms = [] as! Array<SearchRoomResponse>
    var roomId: Int?
    
    // MARK: - view load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.config()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.rooms.removeAll()
        super.viewDidDisappear(animated)
    }
    
    // 다음 화면 이동전 준비동작 (변수 연결)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "MainDetailVC" {
            if let controller = segue.destination as? MainDetailVC {
                controller.roomId = self.roomId
            }
        }
    }
    
    fileprivate func config() {
        // 화면 swipe 기능 연결
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // 스터디룸 조회
        self.getSearchRoom()
        
        // view에 delegate, datasource 연결
        self.studyCollectionView.delegate = self
        self.studyCollectionView.dataSource = self
        
        let studyroomCell = UINib(nibName: "StudyCollectionViewCell", bundle: nil)
        let emptyCell = EmptyCollectionViewCell.nib()
        
        //  셀 리소스 파일 가져와서 등록하기
        studyCollectionView.register(studyroomCell, forCellWithReuseIdentifier: "cell")
        studyCollectionView.register(emptyCell, forCellWithReuseIdentifier: "EmptyCollectionViewCell")
        
        studyCollectionView.showsVerticalScrollIndicator = false // scroll 제거
        studyCollectionView.clearsContextBeforeDrawing = true
    }
    
    // MARK: - search room api
    fileprivate func getSearchRoom() {
        rooms.removeAll()

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
    
    // MARK: - collectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 셀의 갯수 지정
        if rooms.count == 0 {
            return 1
        } else {
            return rooms.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if rooms.isEmpty == true {
            let cell = studyCollectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
            cell.titleLabel.text = "아직 소속된 스터디룸이 없습니다.🥲"
            cell.subtitleLabel.text = "스터디룸은 생성하거나 초대받을 수 있습니다.\n'+'버튼을 통해서 스터디룸을 만들어보세요."
            return cell
        } else {
            let cell = studyCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StudyCollectionViewCell
            cell.layer.cornerRadius = 10
            cell.roomName.text = rooms[indexPath.row].name
            cell.roomMembers.text = String(describing: rooms[indexPath.row].membercount)
            cell.roomMasterName.text = rooms[indexPath.row].mastername
    //        cell.roomImg.imageLoad(urlString: "https://api.ctudy.com\(rooms[indexPath.row].banner)", size: cell.roomImg.image!.size)
            if rooms[indexPath.row].banner != "" {
                cell.roomImg.kf.indicatorType = .activity
                cell.roomImg.kf.setImage(with: URL(string: API.IMAGE_URL + rooms[indexPath.row].banner)!)
            } else {
                cell.roomImg.image = UIImage(named: "studyroom_default.png")
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let cell = CGSize(width: self.studyCollectionView.layer.bounds.width, height: self.studyCollectionView.layer.bounds.height / 1.7)
        
        if rooms.isEmpty == true {
            let cell = CGSize(width: studyCollectionView.layer.bounds.width, height: studyCollectionView.layer.bounds.height)
            return cell
        } else {
            let cell = CGSize(width: studyCollectionView.layer.bounds.width, height: 260)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("MainVC - collectionView didSelectItemAt / selectedItem : \(rooms[indexPath.row].name) choose")
        
        if rooms.isEmpty == true {
            return
        } else {
            self.roomId = rooms[indexPath.row].id
            self.performSegue(withIdentifier: "MainDetailVC", sender: nil)
        }
    }
    
//    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
