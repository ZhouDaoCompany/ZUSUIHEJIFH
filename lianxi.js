'use strict';

//生命全局唯一的 全局变量
var MYAPP = {};

MYAPP.myString = 'hhjsjgchsdchbdsjcabdscfydusgcdjsnvdskjbvdfis';
MYAPP.testMap = new Map();

MYAPP.getString = getTheMostOfTheChar();

console.log(MYAPP.getString);
function getTheMostOfTheChar(testString) {

	if (arguments.length === 0) {
		return '没有值';
	}

	for (let i = 0; i < testString.length; i++) {
	 var str = testString[i];

	 var num = testMap.get(str);

	 if (num) {
	 	testMap.set(str , num + 1);
	 } else {
	 	testMap.set(str , 1);
	 }
	}
	var maxCount = 0;
	for (let arrays of testMap) {
		var num = arrays[1];
		if (num > maxCount) {
			maxCount = num;
		}
	}
	testMap.forEach(function (value, key, map) {
		if (value === maxCount) {
			console.log(key);
			return key;
		}
	});
}

MYAPP.xiaoMing = {

	name : '小明',
	birth: 1990,
	age : function () {
		var y = new Date().getFullYear();
		return y - this.birth;
	}
};

console.log(MYAPP.xiaoMing.age());

MYAPP.arr = ['A','B','C'];
MYAPP.arr.forEach(function (element, index, arrays) {

console.log(element);
});