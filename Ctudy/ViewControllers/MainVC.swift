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

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - 변수
    @IBOutlet var studyCollectionView: UICollectionView!
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = COLOR.INDICATOR_BACKGROUND_COLOR
        return indicatorView
    }()
    lazy var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                type: .pacman,
                                                color: COLOR.BASIC_TINT_COLOR,
                                                padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    lazy var loading: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "loading..."
        label.textColor = COLOR.BASIC_TINT_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
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
    
    // MARK: - indicator in api calling
    fileprivate func onStartActivityIndicator() {
        DispatchQueue.main.async {
            // 불투명 뷰 추가
            self.view.addSubview(self.indicatorView)
            // activity indicator 추가
            self.indicatorView.addSubview(self.indicator)
            self.indicatorView.addSubview(self.loading)
            
            NSLayoutConstraint.activate([
                self.indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.loading.centerYAnchor.constraint(equalTo: self.indicator.bottomAnchor, constant: 5)
            ])
            
            // 애니메이션 시작
            self.indicator.startAnimating()
        }
    }
    
    fileprivate func onStopActivityIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // 애니메이션 정지.
            // 서버 통신 완료 후 다음의 메서드를 실행해서 통신의 끝나는 느낌을 줄 수 있다.
            self.indicator.stopAnimating()
            self.indicatorView.removeFromSuperview()
        }
    }
    
    // MARK: - search room api
    fileprivate func getSearchRoom() {
        rooms.removeAll()
        self.onStartActivityIndicator()

        AlamofireManager.shared.getSearchRoom(completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
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
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - collectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print("MainVC - collectionView count : \(rooms.count)")
        // 셀의 갯수 지정
        return rooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("MainVC - collectionView cellForItemAt / indexPath : \(indexPath.row), roomName : \(rooms[indexPath.row].name), banner : \(rooms[indexPath.row].banner)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StudyCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let cell = CGSize(width: self.studyCollectionView.layer.bounds.width, height: self.studyCollectionView.layer.bounds.height / 1.7)
        let cell = CGSize(width: self.studyCollectionView.layer.bounds.width, height: 260)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("MainVC - collectionView didSelectItemAt / selectedItem : \(rooms[indexPath.row].name) choose")
        self.roomId = rooms[indexPath.row].id
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
