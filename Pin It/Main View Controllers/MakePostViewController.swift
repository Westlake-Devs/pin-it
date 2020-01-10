//
//  MakePostViewController.swift
//  Pin It
//
//  Created by Joseph Jin on 1/9/20.
//  Copyright © 2020 AnimatorJoe. All rights reserved.
//

import UIKit
import LBTATools
import Alamofire

class MakePostViewController: LBTAFormController {

    var titleField = IndentedTextField()
    var descField = UITextField()
    
    let postButton = UIButton(title: "Post", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), target: self, action: #selector(sendPost))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = #colorLiteral(red: 0.1260543499, green: 0.1356953156, blue: 0.1489139211, alpha: 1)
        
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 25
        formContainerStackView.layoutMargins = .init(top: 25, left: 25, bottom: 0, right: 25)
        
        titleField = IndentedTextField(placeholder: "Title", padding: 12, cornerRadius: 5, backgroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), isSecureTextEntry: false)
        titleField.constrainHeight(50)
        formContainerStackView.addArrangedSubview(titleField)
        
        descField = UITextField(placeholder: "Description")
//        let descField = UITextField()
        descField.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        formContainerStackView.addArrangedSubview(descField)
        
        formContainerStackView.addArrangedSubview(postButton)

        // Do any additional setup after loading the view.
    }
    
    
    @objc fileprivate func sendPost() {
        // make post request
        guard let url = URL(string: "http://localhost:3000/") else {
            print("Ah error")
            return
        }

        let data: [String: Any] = [
            "post": [
                "title" : titleField.text!,
                "description" : descField.text!
            ],
            "userLoc": [20, 20]
        ]
        
        print("attempting to send \(data)")
        
        Alamofire.request(URL(string: "http://localhost:3000")!,
                          method: .post,
                          parameters: data,
                          encoding: JSONEncoding.default)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}