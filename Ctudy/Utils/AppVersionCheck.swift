//
//  AppVersion.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/17.
//

import Foundation

// 오류 열거형 타입 enum 선언
enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

class AppVersionCheck {
    static func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary
            , let currentVersion = APP.VERSION as? String // 현재 버전 가져오기
            , let identifier = info["CFBundleIdentifier"] as? String // 앱 번들 아이디 가져오기
            , let url = URL(string: "http://itundes.apple.com/kr/lookup?bundleId=\(identifier)") else { throw VersionError.invalidBundleInfo }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String : Any]
                    , let version = result["version"] as? String else { throw VersionError.invalidResponse } // 앱스토어 버전 가져오기
                let verFloat = NSString.init(string: version).floatValue
                let currentVerFloat = NSString.init(string: currentVersion).floatValue
                
                //현재 버전과 앱스토어 버전 비교하여 bool return (현재버전이 크면 true)
                completion(verFloat > currentVerFloat, nil)
            } catch {
                completion(nil, error)
            }
        })
        task.resume()
        return task
    }
}
