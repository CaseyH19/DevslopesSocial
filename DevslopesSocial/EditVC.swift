//
//  EditVC.swift
//  DevslopesSocial
//
//  Created by Casey on 2/11/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import Firebase

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var descTxt: UITextView!
    @IBOutlet weak var nametxt: FancyField!
    @IBOutlet weak var usernametxt: FancyField!
    @IBOutlet weak var locationtxt: FancyField!
    @IBOutlet weak var datePicker: UIPickerView!
    var datePickerData: [[Int]] = [[Int]]()
    @IBOutlet weak var bdayBtn: FancyBtn!
    
    @IBOutlet weak var profileImg: CircleView!
    
    var yr = "year"
    var mm = "month"
    var dd = "day"
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        self.imagePicker = UIImagePickerController()
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        let yrArr = Array(1900...2017)
        let dtArr = Array(1...31)
        let monthArry = Array(1...12)
        
        datePickerData = [monthArry, dtArr, yrArr.reversed()]
        
        
        
    }
    
    @IBAction func changePicPressed(_ sender: Any) {
        print("KC: Getting new Profile Pic")
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImg.image = image
            imageSelected = true
        } else {
            print("KC: No image was selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ("\(datePickerData[component][row])")
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //bday = " \(datePickerData[0][row])/\(datePickerData[1][row])/\(datePickerData[2][row])"
        //bdayBtn.setTitle(" \(datePickerData[0][row])/\(datePickerData[1][row])/\(datePickerData[2][row])" , for: .normal)
        
        if component == 0 {
            if datePickerData[0][row] >= 10 {
                mm = "\(datePickerData[0][row])"
            } else {
                mm = "0\(datePickerData[0][row])"
            }
        } else if component == 1 {
            if datePickerData[1][row] >= 10 {
                dd = "\(datePickerData[1][row])"
            } else {
                dd = "0\(datePickerData[1][row])"
            }
        } else if component == 2 {
            yr = "\(datePickerData[2][row])"
        }
        
        bdayBtn.setTitle(" \(mm)/\(dd)/\(yr)" , for: .normal)
        print("KC: New birthday Update: \(bdayBtn.currentTitle)")
    }

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bdayPressed(_ sender: Any) {
        guard let text = bdayBtn.currentTitle, text != "" else {
            print("KC: No info passed in")
            return
        }
        print("KC: \(text)")

        if (text.range(of: "Birthday") != nil) || (text.range(of: "day") != nil) || (text.range(of: "year") != nil) || (text.range(of: "month") != nil) {
            print("KC: No info passed/Not completely filled")

        } else {
            print("KC: Filled Bday Field")
            datePicker.isHidden = true
            let pastInfo = DataService.ds.REF_USER_CURRENT.child("info").child("birthday")
            
            pastInfo.setValue(text)
            bdayBtn.setTitle(" Select Birthday" , for: .normal)
            yr = "year"
            mm = "month"
            dd = "day"
        }
    }
    
    @IBAction func selectBday(_ sender: Any){
        datePicker.isHidden = false
        
    }
    
   
    @IBAction func locPressed(_ sender: Any) {
        guard let text = locationtxt.text, text != "" else {
            print("KC: No info passed in")
            return
        }
        
        print("KC: Updating info")
        let pastInfo = DataService.ds.REF_USER_CURRENT.child("info").child("origin")
        
        pastInfo.setValue(locationtxt.text)
        locationtxt.text = ""
    }
    
    @IBAction func userPressed(_ sender: Any) {
        guard let text = usernametxt.text, text != "" else {
            print("KC: No info passed in")
            return
        }
        
        print("KC: Updating info")
        let pastInfo = DataService.ds.REF_USER_CURRENT.child("info").child("username")
        
        pastInfo.setValue(usernametxt.text)
        usernametxt.text = ""
        
        
        
    }
    
    @IBAction func namePressed(_ sender: Any) {
        guard let text = nametxt.text, text != "" else {
            print("KC: No info passed in")
            return
        }
        
        print("KC: Updating info")
        let pastInfo = DataService.ds.REF_USER_CURRENT.child("info").child("name")
        
        pastInfo.setValue(nametxt.text)
        nametxt.text = ""
    }
    
    @IBAction func descPressed(_ sender: Any) {
        guard let text = descTxt.text, text != "" else {
            print("KC: No info passed in")
            return
        }
        
        print("KC: Updating info")
        let pastInfo = DataService.ds.REF_USER_CURRENT.child("info").child("description")
        
        pastInfo.setValue("About Me:\n\(text)")
        descTxt.text = ""
    }
    
    @IBAction func photoPressed(_ sender: Any) {
        guard let imag = profileImg.image, imageSelected == true else {
            print("KC: Photo must be present")
            imageSelected = false
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(imag, 0.2)
        {
            //unique identifier
            let imgUID = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_USER_IMAGES.child(imgUID).put(imgData, metadata: metaData, completion: { (metadata, error) in
                if error != nil {
                    print("KC: unable to upload image to firebase storage")
                }
                else {
                    print("KC: Loaded image to Firebase Storage")
                    
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        let prURL = DataService.ds.REF_USER_CURRENT.child("info").child("profURL")
                        
                        prURL.setValue(url)
                    }
                }
                
            })
            
        }

        imageSelected = false
        profileImg.image = UIImage(named: "blank-profile")
    }
    

}
