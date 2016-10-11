//: Playground - noun: a place where people can play

import UIKit


var tempString = "yyhhjcdncjdbcjvdhdfshdgjsbvvndkv"
var dictt:[String : String] = [:]

var arr1 = Array<String>()
var arr2:[String] = []
var arr3 = Array<String>(repeating: "10", count: 10)




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

/******************************控件******************************************/

var array = Array<String>()

let arr = ["2","4","6","8","10"]




		
