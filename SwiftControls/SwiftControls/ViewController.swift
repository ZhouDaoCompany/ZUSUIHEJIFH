//
//  ViewController.swift
//  SwiftControls
//
//  Created by cqz on 16/10/8.
//  Copyright © 2016年 cqz. All rights reserved.
//

import UIKit

class ViewController: UIViewController , OneViewControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.navigationController?.title = "首页"
        automaticallyAdjustsScrollViewInsets = false
//
//        let view = CustomHeadview(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: 200))
//        view.backgroundColor = UIColor.yellow
//        self.view.addSubview(view)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "二", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.nextPage))
    }
    
    func nextPage()
    {
        
        let  oneVC = OneViewController()
        oneVC.delegate = self
        oneVC.testBlock = { [weak self] (color) in
            
            self?.view.backgroundColor = color
        }
        self.navigationController?.pushViewController(oneVC, animated: true)
        
    }
    
    // MARK: OneViewControllerDelegate
    func changeLastVCBackGroundColor(color: UIColor) {
        
        self.view.backgroundColor = color
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

