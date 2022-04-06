//
//  MemberAPI.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/27.
//

import Foundation
import SwiftyJSON

class MemberAPI {
    
    var isPaginating = false
    
    func fetchData(pagination: Bool = false, completion: @escaping (Result<[String], Error>) -> Void) {
        if pagination {
            isPaginating = true
        }
   
        //DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2), execute: {
        
        
    }
}
