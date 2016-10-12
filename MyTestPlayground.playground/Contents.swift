//: Playground - noun: a place where people can play

import UIKit


var tempString = "yyhhjcdncjdbcjvdhdfshdgjsbvvndkv"
//var dictt:[String : String] = [:]
//
//var arr1 = Array<String>()
//var arr2:[String] = []
//var arr3 = Array<String>(repeating: "10", count: 10)




var dict = Dictionary<Character,Int>()

for ch in tempString.characters {
    
    let keyNum = dict[ch]
    
    if keyNum == nil {
        
        dict[ch] = 1
    }else {
        
        dict[ch] = keyNum! + 1
    }
}

var maxNum = 0

for chCount in dict.values {
    
    if maxNum < chCount  {
        
        maxNum = chCount
    }
}

for (ch,chCount) in dict {

    if maxNum == chCount {
        
        print("打印出来字符最多的是－－－－\(ch)")
    }
}

//集合
let arr11 = ["w","d"]
var arr3  = Array<String>()
var arr4:[String] = []
var arr5 = Array<String>(repeating: "33", count: 30)
var mutableDic = Dictionary<String, Int>()
var mutableD: [String : Int] = [:]

/******************************控件******************************************/





		
