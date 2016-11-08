//
//  CalculateHeader.h
//  ZhouDao
//
//  Created by apple on 16/9/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#ifndef CalculateHeader_h
#define CalculateHeader_h


#endif /* CalculateHeader_h */


/*
 头文件
 */
#import "CalculateManager.h"
#import "CalculateShareView.h"


#define CITYDICTIONARY          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"52859",@"北京",@"32658",@"天津",@"52962",@"上海",@"37173",@"江苏省",@"26152",@"河北省",@"25576",@"河南省",@"28838",@"湖南省",@"27051",@"湖北省",@"43714",@"浙江省",@"24299",@"云南省",@"26420",@"陕西省",@"24579.64",@"贵州省",@"24669",@"广西壮族自治区",@"31195",@"黑龙江省",@"20804",@"甘肃省",@"24901",@"吉林省",@"26205",@"四川省",@"30192.9",@"广东省",@"26500",@"江西省",@"22306.57",@"青海省",@"31126",@"辽宁省",@"31545",@"山东省",@"20023",@"西藏自治区",@"27239",@"重庆",@"33275",@"福建省",@"23214",@"新疆维吾尔自治区",@"28350",@"内蒙古自治区",@"25828",@"山西省",@"24487",@"海南省",@"23285",@"宁夏回族自治区",@"26936",@"安徽省", nil]

#define RURALDICTIONARY          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20569",@"北京市",@"15405",@"天津市",@"23205",@"上海市",@"16257",@"江苏省",@"11051",@"河北省",@"10853",@"河南省",@"10993",@"湖南省",@"11844",@"湖北省",@"21125",@"浙江省",@"7456",@"云南省",@"8689",@"陕西省",@"7386.87",@"贵州省",@"7565",@"广西壮族自治区",@"11422",@"黑龙江省",@"5376",@"甘肃省",@"11326",@"吉林省",@"10247",@"四川省",@"12245.6",@"广东省",@"11139",@"江西省",@"7282.73",@"青海省",@"12057",@"辽宁省",@"12930",@"山东省",@"6578",@"西藏自治区",@"10505",@"重庆市",@"13793",@"福建省",@"8742",@"新疆维吾尔自治区",@"9976",@"内蒙古自治区",@"9454",@"山西省",@"9913",@"海南省",@"8140",@"宁夏回族自治区",@"10821",@"安徽省", nil]

#define TIMEARRAYS      [NSMutableArray arrayWithObjects:@"19890201",@"19900821",@"19910321",@"19910421",@"19930515",@"19930711",@"19950101",@"19950701",@"19960501",@"19960823",@"19971023",@"19980325",@"19980701",@"19981207",@"19990610",@"20020221",@"20041029",@"20050317",@"20060428",@"20060819",@"20070318",@"20070519",@"20070721",@"20070822",@"20070915",@"20071221",@"20080916",@"20081009",@"20081027",@"20081030",@"20081127",@"20081223",@"20101020",@"20101226",@"20110209",@"20110406",@"20110707",@"20120608",@"20120706",@"20141122",@"20150301",@"20150511",@"20150628",@"20150826",@"20151024",nil]

#define RATEDICTIONARY  [NSMutableDictionary dictionaryWithObjectsAndKeys:@[@"0.1134",@"0.1134",@"0.1278",@"0.1440",@"0.1926"],@"19890201",@[@"0.0864",@"0.0936",@"0.1008",@"0.1080",@"0.1116"],@"19900821",@[@"0.0900",@"0.1008",@"0.1080",@"0.1152",@"0.1188"],@"19910321",@[@"0.0810",@"0.0864",@"0.0900",@"0.0954",@"0.0972"],@"19910421",@[@"0.0882",@"0.0936",@"0.1080",@"0.1206",@"0.1224"],@"19930515",@[@"0.0900",@"0.1098",@"0.1224",@"0.1386",@"0.1404"],@"19930711",@[@"0.0900",@"0.1098",@"0.1296",@"0.1458",@"0.1476"],@"19950101",@[@"0.1008",@"0.1206",@"0.1305",@"0.1512",@"0.1530"],@"19950701",@[@"0.0972",@"0.1098",@"0.1314",@"0.1494",@"0.1512"],@"19960501",@[@"0.0918",@"0.1008",@"0.1098",@"0.1170",@"0.1242"],@"19960823",@[@"0.0765",@"0.0864",@"0.0936",@"0.0990",@"0.1053"],@"19971023",@[@"0.0702",@"0.0792",@"0.0900",@"0.0972",@"0.1035"],@"19980325",@[@"0.0657",@"0.0693",@"0.0711",@"0.0765",@"0.0801"],@"19980701",@[@"0.0612",@"0.0639",@"0.0666",@"0.0720",@"0.0756"],@"19981207",@[@"0.0558",@"0.0585",@"0.0594",@"0.0603",@"0.0621"],@"19990610",@[@"0.0504",@"0.0531",@"0.0549",@"0.0558",@"0.0576"],@"20020221",@[@"0.0522",@"0.0558",@"0.0576",@"0.0585",@"0.0612"],@"20041029",@[@"0.0522",@"0.0558",@"0.0576",@"0.0585",@"0.0612"],@"20050317",@[@"0.0540",@"0.0585",@"0.0603",@"0.0612",@"0.0639"],@"20060428",@[@"0.0558",@"0.0612",@"0.0630",@"0.0648",@"0.0684"],@"20060819",@[@"0.0567",@"0.0639",@"0.0657",@"0.0675",@"0.0711"],@"20070318",@[@"0.0585",@"0.0657",@"0.0675",@"0.0693",@"0.0720"],@"20070519",@[@"0.0603",@"0.0684",@"0.0702",@"0.0720",@"0.0738"],@"20070721",@[@"0.0621",@"0.0702",@"0.0720",@"0.0738",@"0.0756"],@"20070822",@[@"0.0648",@"0.0729",@"0.0747",@"0.0765",@"0.0783"],@"20070915",@[@"0.0657",@"0.0747",@"0.0756",@"0.0774",@"0.0783"],@"20071221",@[@"0.0621",@"0.0720",@"0.0729",@"0.0756",@"0.0774"],@"20080916",@[@"0.0612",@"0.0693",@"0.0702",@"0.0729",@"0.0747"],@"20081009",@[@"0.0612",@"0.0693",@"0.0702",@"0.0729",@"0.0747"],@"20081027",@[@"0.0603",@"0.0666",@"0.0675",@"0.0702",@"0.0720"],@"20081030",@[@"0.0504",@"0.0558",@"0.0567",@"0.0594",@"0.0612"],@"20081127",@[@"0.0486",@"0.0531",@"0.0540",@"0.0576",@"0.0594"],@"20081223",@[@"0.0510",@"0.0556",@"0.0560",@"0.0596",@"0.0614"],@"20101020",@[@"0.0535",@"0.0581",@"0.0585",@"0.0622",@"0.0640"],@"20101226",@[@"0.0560",@"0.0606",@"0.0610",@"0.0645",@"0.0660"],@"20110209",@[@"0.0585",@"0.0631",@"0.0640",@"0.0665",@"0.0680"],@"20110406",@[@"0.0610",@"0.0656",@"0.0665",@"0.0690",@"0.0705"],@"20110707",@[@"0.0585",@"0.0631",@"0.0640",@"0.0665",@"0.0680"],@"20120608",@[@"0.0560",@"0.0600",@"0.0615",@"0.0640",@"0.0655"],@"20120706",@[@"0.0560",@"0.0560",@"0.0600",@"0.0600",@"0.0615"],@"20141122",@[@"0.0535",@"0.0535",@"0.0575",@"0.0575",@"0.0590"],@"20150301",@[@"0.0510",@"0.0510",@"0.0550",@"0.0550",@"0.0565"],@"20150511",@[@"0.0485",@"0.0485",@"0.0525",@"0.0525",@"0.0540"],@"20150628",@[@"0.0460",@"0.0460",@"0.0500",@"0.0500",@"0.0515"],@"20150826",@[@"0.0435",@"0.0435",@"0.0475",@"0.0475",@"0.0490"],@"20151024", nil]
