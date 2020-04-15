//
//  EditPostViewController.swift
//  Pin It
//
//  Created by Joseph Jin on 4/13/20.
//  Copyright © 2020 AnimatorJoe. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import GoogleSignIn
import PromiseKit
import AwaitKit
import Eureka
import MultiImageRow
import NVActivityIndicatorView

class EditPostViewController: FormViewController {
    
    var e: Entry!
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = #colorLiteral(red: 0.1260543499, green: 0.1356953156, blue: 0.1489139211, alpha: 1)
        self.isModalInPresentation = true
        createForm()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Get Entry
    func useEntry(_ e: Entry) {
        self.e = e
    }
    
    // MARK: On Edit Complete
    func onEditComplete(_ completion : @escaping (() -> Void)) {
        self.completion = completion
    }

    // MARK: Create Form
    func createForm() {
        form
            // Title and description fields
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIView>(.callback({
                        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                        let title = UILabel(frame: CGRect(x: 16, y: 0, width: 500, height: 100))
                        title.font = .boldSystemFont(ofSize: 40)
                        title.text = "Edit Post"
                        title.textColor = .white
                        view.addSubview(title)
                        return view
                    }))
                    header.height = { 100 }
                    return header
                    }()
            }

            <<< TextRow() { row in
                row.placeholder = "Write a title..."
                row.value = e.title
                row.tag = "title"
            }
            .cellSetup{ cell, row in
                cell.tintColor = .white
            }
            
            <<< TextAreaRow() { row in
                row.placeholder = "Write a description..."
                row.value = e.desc
                row.tag = "desc"
            }
            .cellSetup { cell, row in
                cell.height = { 150 }
            }
            
            // Button rows
            +++ Section()
            <<< ButtonRow { button in
                button.title = "Save"
            }
            .cellSetup { cell, row in
                cell.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                cell.tintColor = .white
            }
            .onCellSelection { cell, row in
                guard let titleField = self.form.rowBy(tag: "title")!.baseValue as! String?,
                    let descField = self.form.rowBy(tag: "desc")!.baseValue as! String? else {
                    WarningPopup.issueWarningOnIncompletePost(vc: self)
                    return
                }
                EntriesManager.editPostFields(ofPost: self.e, writes: ["title" : titleField, "description" : descField]).done { _ in
                    self.dismiss(animated: true) {
                        if let completion = self.completion { completion() }
                    }
                }.catch { (err) in
                    WarningPopup.issueWarning(title: "Error", description: err as! String, vc: self)
                }
            }
            
            <<< ButtonRow { (row: ButtonRow) -> Void in
                row.title = "Cancel"
            }
            .cellSetup{ cell, row in
                cell.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                cell.tintColor = .white
            }
            .onCellSelection { cell, row in
                self.dismiss(animated: true)
            }
    }

}