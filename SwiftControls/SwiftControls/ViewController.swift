//
//  ViewController.swift
//  SwiftControls
//
//  Created by cqz on 16/10/8.
//  Copyright © 2016年 cqz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*******************控件************************/
        let btn1 = UIButton(type: UIButtonType.infoDark)
        btn1.frame = CGRect(x: 130, y: 80, width: 40,height: 40)
        
        let btn2 = UIButton(type: UIButtonType.roundedRect)
        btn2.frame = CGRect(x: 80, y: 180, width: 150,height: 40)
        btn2.setTitle("tap me", for: UIControlState.normal)
        btn2.backgroundColor = UIColor.blue
        btn2.tintColor = UIColor.yellow
        btn2.layer.masksToBounds = true
        btn2.layer.cornerRadius = 10
        btn2.layer.borderWidth = 2
        btn2.layer.borderColor = UIColor.green.cgColor
        btn2.addTarget(self, action: #selector(ViewController.btnTap(_:)), for: UIControlEvents.touchUpInside)
        
        let btn3 = UIButton(type: UIButtonType.roundedRect)
        btn3.frame = CGRect(x: 80, y: 280, width: 150,height: 40)
        btn3.backgroundColor = UIColor.blue
        btn3.setTitle("点我", for: UIControlState.normal)
        btn3.layer.masksToBounds = true
        btn3.layer.cornerRadius = 10
        btn3.layer.borderColor = UIColor.red.cgColor
        btn3.addTarget(self, action: #selector(ViewController.btnTap(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(btn3)
        self.view.addSubview(btn2)
        self.view.addSubview(btn1)

        
        
    }
    
    func btnTap(_ button:UIButton) {
        
        
        let alert = UIAlertController(title: "标题", message: "按钮事件", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

