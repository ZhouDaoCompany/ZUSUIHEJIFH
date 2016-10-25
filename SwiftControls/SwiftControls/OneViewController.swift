//
//  OneViewController.swift
//  SwiftControls
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 cqz. All rights reserved.
//

import UIKit

typealias FuncBlock = (_ color : UIColor) ->Void
protocol OneViewControllerDelegate {

    func changeViewColor(color : UIColor)
}
class OneViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource  {
    
    var testBlock : FuncBlock!
    var delegate  : OneViewControllerDelegate!
    var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        automaticallyAdjustsScrollViewInsets = false
        let rect = CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64)
        tableView = UITableView(frame: rect)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.view.addSubview(tableView)
        
//        self.view.addSubview(blockBtn)
//        self.view.addSubview(delegateBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Block
    func blockDelegateEvent(btn : UIButton) {
        
        let index = btn.tag
        
        if index == 2001 {
            
            if testBlock != nil {
                testBlock(RandomColor())
            }
        }else {
            
            if delegate != nil {
                
                delegate.changeViewColor(color: RandomColor())
            }
        }
        
        self.navigationController!.popViewController(animated: true)
        
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.textLabel?.font = FONT(size: 14)
        cell?.textLabel?.text = "第\(indexPath.row)行"
        let url = NSURL(string: "http://img5.imgtn.bdimg.com/it/u=1557665204,456911937&fm=21&gp=0.jpg")
//        cell?.imageView?.sd_setImage(with: url as URL!, placeholderImage: UIImage(named: "003.jpg"))
        let data = NSData(contentsOf: url as! URL)
        let image = UIImage(data: data as! Data)
        
        
        let imgView = UIImageView(frame: CGRect(x: ScreenWidth - 75, y: 10, width: 60, height: 60))
//        imgView.sd_setImage(with: url as URL!, placeholderImage: UIImage(named: "003.jpg"))
        imgView.image = image
        imgView.isUserInteractionEnabled = true
        cell?.contentView.addSubview(imgView)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "提示", message: "点击的是第\(indexPath.row)行", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
            print("点击了确定")
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true) { 
            
            print("弹出来了")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80;
    }
    //MARK: setter and getter
    
    private var delegateBtn : UIButton {
        
        let rect = CGRect(x: ScreenWidth - 115, y: 100, width: 100, height: 100)
        let delegateBtn = UIButton(frame: rect)
        delegateBtn.backgroundColor = UIColor.black
        delegateBtn.setTitle("block", for: UIControlState.normal)
        delegateBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        delegateBtn.tag = 2002
        delegateBtn.addTarget(self, action: #selector(blockDelegateEvent), for: UIControlEvents.touchUpInside)
        return delegateBtn
    }
    
    private var blockBtn : UIButton {
        
        let rect = CGRect(x: 15, y: 100, width: 100, height: 100)
        let blockBtn = UIButton(frame: rect)
        blockBtn.backgroundColor = UIColor.black
        blockBtn.setTitle("block", for: UIControlState.normal)
        blockBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        blockBtn.tag = 2001
        blockBtn.addTarget(self, action: #selector(blockDelegateEvent), for: UIControlEvents.touchUpInside)
        return blockBtn
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
