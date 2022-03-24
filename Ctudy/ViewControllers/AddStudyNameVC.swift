//
//  AddRoomVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/22.
//

import Foundation
import UIKit

class AddStudyNameVC : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var registerStudyName: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "AddStudyMemberVC" {
            if let controller = segue.destination as? AddStudyMemberVC {
                controller.studyName = self.registerStudyName.text
            }
        }
    }
    
    fileprivate func config() {
        self.registerStudyName.text = ""
        self.registerStudyName.delegate = self
        self.nextBtn.layer.cornerRadius = 30
        self.nextBtn.layer.borderWidth = 1
        self.nextBtn.layer.borderColor = UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1).cgColor
        self.nextBtn.isEnabled = false
        self.nextBtn.addTarget(self, action: #selector(onNextBtnClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if self.registerStudyName.text!.isEmpty {
            self.nextBtn.isEnabled = false
        } else {
            self.nextBtn.isEnabled = true
        }
    }
    
    @objc func onNextBtnClicked(_ sender: Any) {
        print("onNextBtnClicked() called")
        self.performSegue(withIdentifier: "AddStudyMemberVC", sender: nil)
    }
}
