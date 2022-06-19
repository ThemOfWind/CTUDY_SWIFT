//
//  Tokens.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/29.
//

import Foundation
import Security
import Alamofire

class KeyChainManager {
    // 키 체인에 값 저장
    func tokenSave(_ service: String, account: String, value: String) -> Bool {
        // 키 체인 쿼리
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword // 아이템 클래스 (어떤 타입의 데이터를 저장할지)
          , kSecAttrService: service // 서비스 아이디 (앱 번들 아이디)
          , kSecAttrAccount: account // 사용자 계정
          , kSecValueData: value.data(using: .utf8, allowLossyConversion: false)! // 저장할 값
            ]
        
        // 기존 키 체인 아이템 제거 (덮어쓰기 못함)
        SecItemDelete(keyChainQuery)
        
        // 새로운 키 체인 아이템 등록
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        
        if (status == errSecSuccess) {
            return true
        } else {
            NSLog("status: \(AuthErrors.noSaveToken)")
            return false
        }
    }
    
    // 키 체인에 저장된 값 읽기
    func tokenLoad(_ service: String, account: String) -> String? {
        // 키 체인 쿼리
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword
          , kSecAttrService: service
          , kSecAttrAccount: account
          , kSecReturnData: kCFBooleanTrue
          , kSecMatchLimit: kSecMatchLimitOne
            ]
        
        // 키 체인에 저장된 값 읽기
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        
        // 처리 결과가 성공일때, 결과값 -> Data타입 -> String타입으로 변환 후 return
        if (status == errSecSuccess) {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else { // 실패일때, nil return
            print("Nothing was retrieved from the keychain. Status code \(status)")
            return nil
        }
    }
    
    // 키 체인에 값 삭제
    func tokenDelete(_ service: String, account: String) -> Bool {
        // 키 체인 쿼리
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword
          , kSecAttrService: service
          , kSecAttrAccount: account
            ]
        
        // 키 체인에 저장된 값 삭제
        let status = SecItemDelete(keyChainQuery)
        if (status == errSecSuccess) {
            return true
        } else {
            NSLog("status: \(AuthErrors.noDelToken)")
            return false
        }
    }
    
//    // 키 체인에 저장된 엑세스 토큰을 이용해 헤더를 만듬 -> 사용 안할듯?
//    func getAuthorizationHeader() -> HTTPHeaders? {
//        if let accessToken = self.tokenLoad(API.SERVICEID, account: "accessToken") {
//            return ["Authorization": "Bearer \(accessToken)"] as HTTPHeaders
//        } else {
//            return nil
//        }
//    }
}
