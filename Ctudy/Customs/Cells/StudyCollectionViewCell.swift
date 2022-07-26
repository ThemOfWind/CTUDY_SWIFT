//
//  StudyCollectionViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/01/06.
//

import Foundation
import UIKit

class StudyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roomViewCell: UIView!
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomMasterImg: UIImageView!
    @IBOutlet weak var roomMasterName: UILabel!
    @IBOutlet weak var roomMemberImg: UIImageView!
    @IBOutlet weak var roomMembers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // room Cell
        self.roomViewCell.layer.cornerRadius = 10
        self.roomViewCell.layer.borderWidth = 1
        self.roomViewCell.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        
        // room lmg
        self.roomImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.roomImg.tintColor = COLOR.BASIC_TINT_COLOR
        //        self.roomImg.image = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .large))
        //        self.roomImg.imageLoad(urlString: API.IMAGE_DEFAULT_URL, size: CGSize(width: self.roomStackViewCell.layer.bounds.width, height: roomImg.layer.bounds.height))
        self.roomImg.image = UIImage(named: "studyroom_default.png")
        self.roomImg.contentMode = .scaleAspectFill
        self.roomImg.translatesAutoresizingMaskIntoConstraints = false
        
        // roomName label
        self.roomName.textColor = COLOR.SIGNATURE_COLOR
        
        // roomMaster
        self.roomMasterImg.tintColor = COLOR.SIGNATURE_COLOR
        self.roomMasterName.textColor = COLOR.SIGNATURE_COLOR
        
        // roomMembers
        self.roomMemberImg.tintColor = COLOR.SIGNATURE_COLOR
        self.roomMembers.textColor = COLOR.SIGNATURE_COLOR
    }
}

//extension UIImageView {
//    func imageLoad(urlString: String, size: CGSize) {
//        let url = URL(string: urlString)!
//        
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image.imageResize(size: size, scale: UIScreen.main.scale)
//                    }
//                }
//            } 
//        }
//    }
//}
//
//extension UIImage {
//    //    // 원하는 해상도에 맞게 조절
//    //    func resize(scale: CGFloat) -> UIImage {
//    //        let imageSourceOption = [ kCGImageSourceShouldCache: false ] as CFDictionary
//    //        let data = self.pngData()! as CFData
//    //        let imageSource = CGImageSourceCreateWithData(data, nil)!
//    //        let maxPixel = max(self.size.width, self.size.height) * scale
//    //        let downSampleOptions = [ kCGImageSourceCreateThumbnailFromImageAlways: true
//    //                                  , kCGImageSourceShouldCacheImmediately: true
//    //                                  , kCGImageSourceCreateThumbnailWithTransform: true
//    //                                  , kCGImageSourceThumbnailMaxPixelSize: maxPixel
//    //                                ] as CFDictionary
//    //        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!
//    //        let newImage = UIImage(cgImage: downSampledImage)
//    //
//    //        return newImage
//    //    }
//    
//    // 이미지뷰 크기에 맞게 조절
//    func imageResize(size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
//        let imageSourceOption = [ kCGImageSourceShouldCache: false ] as CFDictionary
//        let data = self.pngData()! as CFData
//        let imageSource = CGImageSourceCreateWithData(data, imageSourceOption)!
//        let maxPixel = max(size.width, size.height) * scale
//        let downSampleOptions = [ kCGImageSourceCreateThumbnailFromImageAlways: true
//                                  , kCGImageSourceShouldCacheImmediately: true
//                                  , kCGImageSourceCreateThumbnailWithTransform: true
//                                  , kCGImageSourceThumbnailMaxPixelSize: maxPixel
//        ] as CFDictionary
//        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!
//        let newImage = UIImage(cgImage: downSampledImage)
//        
//        return newImage
//    }
//}
