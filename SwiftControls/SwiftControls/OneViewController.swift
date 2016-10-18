//
//  OneViewController.swift
//  SwiftControls
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 cqz. All rights reserved.
//

import UIKit

protocol OneViewControllerDelegate {
    
    func changeBackGroundColor()
}

class OneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "第二页"
        
        let rect = CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64)
        
        tableView = UITableView(frame: rect, style: UITableViewStyle.grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.view.addSubview(tableView)
        
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as UITableViewCell!
        
        cell?.textLabel?.font = FONT(size: 15)
        cell?.textLabel?.text = "第 \(indexPath.row)行"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
