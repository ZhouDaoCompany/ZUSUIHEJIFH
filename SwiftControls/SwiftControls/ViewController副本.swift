//
//  ViewController.swift
//  SwiftControls
//
//  Created by cqz on 16/10/8.
//  Copyright © 2016年 cqz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate ,UIScrollViewDelegate{

    var tableView : UITableView!
    var btn : UIButton!
    var lab : UILabel!
    var webView : UIWebView!
    var _timer = Timer()
    var _indexCount : Int = 0
    var _uiScrollView : UIScrollView!
    var _isScr : Bool! = false
    
    
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
//        let label = UILabel(frame: CGRect(x: 80, y: 80, width: 200, height: 100))
//        label.backgroundColor = UIColor.cyan
//        label.textAlignment = NSTextAlignment.center;
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.text = "岁月难得沉默 秋风厌倦漂泊 夕阳赖着不走挂在墙头舍不得我 昔日伊人耳边话 已和潮声向东流 再回首往事也随枫叶一片片落 爱已走到尽头 恨也放弃承诺 命运自认幽默 想法太多由不得"
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        self.view.addSubview(label)
        
        //UISwitch
    
//        let rect = CGRect(x: 50, y: 100, width: 100, height: 40)
//        let uiswitch = UISwitch(frame: rect)
//        uiswitch.backgroundColor = UIColor.clear
//        uiswitch.setOn(true, animated: true)
//        uiswitch.addTarget(self, action: #selector(ViewController.switchChange(_:)), for: UIControlEvents.valueChanged)
//        self.view.addSubview(uiswitch)
        
        
        //UIStepper
//        lab = UILabel(frame: CGRect(x: 10, y: 64, width: 100, height: 20))
//        lab.font = UIFont.systemFont(ofSize: 18)
//        lab.backgroundColor = UIColor.cyan
//        self.view.addSubview(lab)
//        
//        let stepper = UIStepper(frame: CGRect(x: 110, y: 64, width: 60, height: 40))
//        stepper.backgroundColor = UIColor.yellow
//        stepper.maximumValue = 10
//        stepper.minimumValue = 0
//        stepper.stepValue = 1
//        stepper.addTarget(self, action: #selector(stepperEvent(stepper:)), for: UIControlEvents.valueChanged)
//        self.view.addSubview(stepper)
        
        //UITextField
//        let rect = CGRect(x: 70, y: 120, width: 90, height: 30)
//        let textFild = UITextField(frame: rect)
//        textFild.backgroundColor = UIColor.black
//        textFild.textColor = UIColor.white
//        textFild.autocorrectionType = UITextAutocorrectionType.no
//        textFild.placeholder = "此处填写文字"
//        textFild.clearButtonMode = UITextFieldViewMode.whileEditing
//        textFild.keyboardType = UIKeyboardType.emailAddress
//        textFild.keyboardAppearance = UIKeyboardAppearance.dark
//        textFild.delegate = self
//        self.view.addSubview(textFild)
        
        
        
        //UIWebView
//        let rect = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64)
//        webView = UIWebView(frame: rect)
//        webView.backgroundColor = UIColor.blue
//        let url = URL(string: "https://www.baidu.com")
//        let request = URLRequest(url: url!)
//        webView.loadRequest(request)
//        self.view.addSubview(webView)
        
        //UIScrollView
         let rect = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64)
        _uiScrollView = UIScrollView(frame: rect)
        _uiScrollView.backgroundColor = UIColor.red
        _uiScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * 3, height: UIScreen.main.bounds.size.height - 64)
        _uiScrollView.delegate = self
        _uiScrollView.showsVerticalScrollIndicator = false
        _uiScrollView.showsHorizontalScrollIndicator = false
        _uiScrollView.isPagingEnabled = true
        self.view.addSubview(_uiScrollView)
        
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64))
        image1.image = UIImage(named: "001.jpg")
        _uiScrollView.addSubview(image1)
        
        let image2 = UIImageView(frame: CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64))
        image2.image = UIImage(named: "002.jpg")
        image2.contentMode = UIViewContentMode.scaleAspectFit
        _uiScrollView.addSubview(image2)

        let image3 = UIImageView(frame: CGRect(x: UIScreen.main.bounds.size.width * 2, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64))
        image3.image = UIImage(named: "003.jpg")
        _uiScrollView.addSubview(image3)

        if #available(iOS 10.0, *) {

            _timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (Timer) in
                
                self.timerStart()
            })
        } else {
            // Fallback on earlier versions
            _timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerStart), userInfo: nil, repeats: true)
            
        }
        
        //计算哪个字符
//        let myTestString = "jkgjdgjhhshssdfg"
//        
//        var tempDict = Dictionary<Character, Int>()
//        
//        for ch in myTestString.characters {
//            
//            let num = tempDict[ch]
//            
//            if  num == nil {
//                tempDict[ch] = 1
//            } else {
//                tempDict[ch] = num! + 1
//            }
//            
//        }
//        
//        var maxCount = 0
//        
//        for count in tempDict.values {
//            
//            if maxCount < count {
//                
//                maxCount = count
//            }
//        }
//        
//        for (ch, counts) in tempDict {
//            
//            if counts == maxCount {
//                
//                print("最多的字符是－－－－\(ch)")
//            }
//        }
        
    }
    
    func timerStart()  {
        
        print("开始")
        if _isScr == false {
            
            if _indexCount < 3 {
                
                _indexCount += 1
            }
            if _indexCount == 3 {
                
                _indexCount = 2
                _isScr = true
            }
        }
        
        if _isScr == true  {
            
            _indexCount -= 1
            
            if _indexCount == -1 {
                
                _indexCount = 0
                _isScr = false
            }
        }
        
        
        let x =  UIScreen.main.bounds.size.width * (CGFloat)(_indexCount)
        
        let srcPoint = CGPoint(x: x, y: 0)
        _uiScrollView.setContentOffset(srcPoint, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        
    }
    
    //MARK    UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func stepperEvent(stepper: UIStepper) {
    
        let value = stepper.value
        
        lab.text = "\(value)"
    }
    
    func switchChange(_ uiSwitch:UISwitch)  {
        
        var message = "打开开关"
        
        if (!uiSwitch.isOn) {
            
            message = "关闭开关"
        }
        
        let alert = UIAlertController(title: "提示框", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
            print("点击消失")
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
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
        
//        let identifer = "cellID"
//        
//        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
//        
//        if (cell == nil) {
//            
//            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifer)
//        }
//        cell?.selectionStyle = UITableViewCellSelectionStyle.none
//        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
//        cell?.textLabel?.textColor = UIColor.red
//        cell?.textLabel?.text = "第几行:  \(indexPath.row)"
//        return cell!
        
        let identifer = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifer)
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.textLabel?.textColor = UIColor.darkText
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.textLabel?.text = "第\(indexPath.row)行"
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

