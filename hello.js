
'use strict';
var x = 1;
var testString = 'gasjcjkasckjakchhhh';

var str =  takeOutMostOfTheCharacters(testString);
	console.log(str);


//输出字串中最多的字符
function takeOutMostOfTheCharacters(testString) {

	var testMap = new Map();
	for (var i = testString.length - 1; i >= 0; i--) {
	
	var tempString = testString[i];
	var num = testMap.get(tempString);

	if (num) { 

       testMap.set(tempString , num + 1);
	}else {

		testMap.set(tempString , 1);
	}	
   }

    console.log(testMap);
    var maxNum = 0

for (var tempArrays of testMap) {

	var num = tempArrays[1];
	if (num > maxNum) {
		maxNum = num;
	}
}
for (var tempArrays of testMap) {

	var num = tempArrays[1];
	if (num === maxNum) {

		var maxString = tempArrays[0];
		return maxString;
	}
}

}





















