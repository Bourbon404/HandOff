//
//  ViewController.swift
//  iFont
//
//  Created by 郑伟 on 2019/3/8.
//  Copyright © 2019 BourbonZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var defaultString : String!
    var tableView : UITableView!
    
    override func loadView() {
        super.loadView()
        
        self.title = "system font 系统默认字体"
        
        self.tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.grouped)
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView.init()
        self.tableView.sectionFooterHeight = 0
        self.view.addSubview(self.tableView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showCustomString))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(revert))
    }
    
    //Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return UIFont.familyNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let familyName = UIFont.familyNames[section]
        let familyFont = UIFont.fontNames(forFamilyName: familyName)
        return familyFont.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let familyName = UIFont.familyNames[indexPath.section]
        let familyFont = UIFont.fontNames(forFamilyName: familyName)
        let font = UIFont.init(name: familyFont[indexPath.row], size: 15)
        cell.textLabel?.font = font
        
        if (self.defaultString != nil) {
            cell.textLabel?.text = self.defaultString + " ---- " + (font?.fontName)!
        } else {
            cell.textLabel?.text = "default ---  默认 ----" + (font?.fontName)!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let familyName = UIFont.familyNames[section]
        return familyName
    }
  
    //Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let familyName = UIFont.familyNames[indexPath.section]
        let familyFont = UIFont.fontNames(forFamilyName: familyName)
        let font = UIFont.init(name: familyFont[indexPath.row], size: 15)
        
        let alert = UIAlertController.init(title: "font name", message: (font?.fontName)!, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let action = UIAlertAction.init(title: "Copy name to pasteboard", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(cancel)
        alert.addAction(action)
        self.present(alert, animated: true) {
            UIPasteboard.general.string = (font?.fontName)!
        }
    }
 
    //Action
    @objc func showCustomString() -> Void {
        let alert = UIAlertController.init(title: "Field custom string", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (field) in
            field.placeholder = "default ---  默认 ----"
        }
        let action = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let done = UIAlertAction.init(title: "Done", style: UIAlertAction.Style.default) { (action) in
            let field = alert.textFields?.first
            if ((field?.text) != nil) {
                self.defaultString = (field?.text)!
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func revert() -> Void {
        self.defaultString = "default ---  默认 ----"
        self.tableView.reloadData()
    }
}

