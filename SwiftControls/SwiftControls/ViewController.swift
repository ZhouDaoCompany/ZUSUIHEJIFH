//
//  ViewController.swift
//  SwiftControls
//
//  Created by cqz on 16/10/8.
//  Copyright © 2016年 cqz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    var btn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*******************控件************************/
        //按钮
//        let btn1 = UIButton(type: UIButtonType.infoDark)
//        btn1.frame = CGRect(x: 130, y: 80, width: 40,height: 40)
//        
//        
//        let btn2 = UIButton(type: UIButtonType.roundedRect)
//        btn2.frame = CGRect(x: 80, y: 180, width: 150, height: 44)
//        btn2.backgroundColor = UIColor.purple
//        btn2.tintColor = UIColor.cyan
//        btn2.setTitle("戳我", for: UIControlState.normal)
//        btn2.layer.masksToBounds = true
//        btn2.layer.cornerRadius = 5
//        btn2.layer.borderWidth = 2
//        btn2.layer.borderColor = UIColor.lightGray.cgColor
//        btn2.addTarget(self, action: #selector(ViewController.btnTap(_:)), for: UIControlEvents.touchUpInside)
//        
//        
//        let btn3 = UIButton(type: UIButtonType.roundedRect)
//        btn3.frame = CGRect(x: 80, y: 280, width: 150,height: 40)
//        btn3.backgroundColor = UIColor.blue
//        btn3.setTitle("点我", for: UIControlState.normal)
//        btn3.layer.masksToBounds = true
//        btn3.layer.cornerRadius = 10
//        btn3.layer.borderColor = UIColor.red.cgColor
//        btn3.addTarget(self, action: #selector(ViewController.btnTap(_:)), for: UIControlEvents.touchUpInside)
//        
//        self.view.addSubview(btn3)
//        self.view.addSubview(btn2)
//        self.view.addSubview(btn1)
        
        //表
//        self.automaticallyAdjustsScrollViewInsets = true
//        self.edgesForExtendedLayout = UIRectEdge(rawValue: UInt(0))
//        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64), style: UITableViewStyle.grouped)
//        tableView.backgroundColor = UIColor.brown
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        tableView.delegate = self
//        tableView.dataSource = self
//        self.view.addSubview(tableView)
        
        //UILabel
        let label = UILabel(frame: CGRect(x: 80, y: 80, width: 200, height: 40))
        label.backgroundColor = UIColor.cyan
        label.textAlignment = NSTextAlignment.center;
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "标签 \n展示"
        label.numberOfLines = 0
        self.view.addSubview(label)
        //
        
    }
    
    func btnTap(_ button:UIButton) {
        
        
        let alert = UIAlertController(title: "标题", message: "此处展示信息", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            
            print("打印信息")
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    //Mark 表的代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifer = "cellID"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        
        if (cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifer)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.textLabel?.textColor = UIColor.red
        cell?.textLabel?.text = "第几行:  \(indexPath.row)"
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "标题", message: "点击的第几行cell  \(indexPath.row)", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            
            print("不正确 点击的应该是这一行的cell \(indexPath.row)")
        }

        let OKAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
            print("点击的确实是 \(indexPath.row) cell")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

