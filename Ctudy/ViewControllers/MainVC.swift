//
//  MainVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation
import UIKit

class MainVC: UIViewController, UICollectionViewDataSource {
    
    var rooms = [SearchRoomResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 셀의 갯수 지정
        if rooms.count <= 0 {
            return 0
        } else {
            return rooms.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 셀 생성
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyCollectionViewCell", for: indexPath)
        return cell
    }
    
    fileprivate func getSearchRoom() {
        AlamofireManager.shared.getSearchRoom(completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let roomList):
                self.rooms = roomList
            case .failure(let error):
                print("MainVC - getSearchRoom.failure / error: \(error)")            }
        })
    }
}
