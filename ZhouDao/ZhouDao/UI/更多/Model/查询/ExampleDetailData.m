//
//  data.m
//  周道
//
//  Created by _author on 16-05-12.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "ExampleDetailData.h"
#import "DTApiBaseBean.h"


@implementation ExampleDetailData

@synthesize appType = _appType;
@synthesize case_date = _case_date;
@synthesize case_no = _case_no;
@synthesize case_no_hash = _case_no_hash;
@synthesize company_id = _company_id;
@synthesize content = _content;
@synthesize create_date = _create_date;
@synthesize create_time = _create_time;
@synthesize createTime = _createTime;
@synthesize credential = _credential;
@synthesize defendant = _defendant;
@synthesize expertiseId = _expertiseId;
@synthesize id = _id;
@synthesize is_analysis = _is_analysis;
@synthesize is_collection = _is_collection;
@synthesize jsonStr = _jsonStr;
@synthesize lawyerId = _lawyerId;
@synthesize limitType = _limitType;
@synthesize modify_date = _modify_date;
@synthesize org_id = _org_id;
@synthesize pageCount = _pageCount;
@synthesize pageNo = _pageNo;
@synthesize pageSize = _pageSize;
@synthesize pre_stage_case_no = _pre_stage_case_no;
@synthesize pre_stage_case_no_hash = _pre_stage_case_no_hash;
@synthesize prosecutor = _prosecutor;
@synthesize resultIds = _resultIds;
@synthesize startIndex = _startIndex;
@synthesize status = _status;
@synthesize timeStamp = _timeStamp;
@synthesize title = _title;
@synthesize totalRecord = _totalRecord;
@synthesize url = _url;
@synthesize url_hash = _url_hash;
@synthesize user_id = _user_id;
@synthesize version = _version;
@synthesize website_id = _website_id;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(appType, @"");
		DTAPI_DICT_ASSIGN_STRING(case_date, @"");
		DTAPI_DICT_ASSIGN_STRING(case_no, @"");
		DTAPI_DICT_ASSIGN_STRING(case_no_hash, @"");
		DTAPI_DICT_ASSIGN_STRING(company_id, @"");
		DTAPI_DICT_ASSIGN_STRING(content, @"");
		DTAPI_DICT_ASSIGN_STRING(create_date, @"");
		DTAPI_DICT_ASSIGN_NUMBER(create_time, @"0");
		DTAPI_DICT_ASSIGN_STRING(createTime, @"");
		DTAPI_DICT_ASSIGN_STRING(credential, @"");
		DTAPI_DICT_ASSIGN_STRING(defendant, @"");
		DTAPI_DICT_ASSIGN_STRING(expertiseId, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_NUMBER(is_analysis, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(is_collection, @"0");
		DTAPI_DICT_ASSIGN_STRING(jsonStr, @"");
		DTAPI_DICT_ASSIGN_STRING(lawyerId, @"");
		DTAPI_DICT_ASSIGN_STRING(limitType, @"");
		DTAPI_DICT_ASSIGN_STRING(modify_date, @"");
		DTAPI_DICT_ASSIGN_STRING(org_id, @"");
		DTAPI_DICT_ASSIGN_STRING(pageCount, @"");
		DTAPI_DICT_ASSIGN_NUMBER(pageNo, @"0");
		DTAPI_DICT_ASSIGN_NUMBER(pageSize, @"0");
		DTAPI_DICT_ASSIGN_STRING(pre_stage_case_no, @"");
		DTAPI_DICT_ASSIGN_STRING(pre_stage_case_no_hash, @"");
		DTAPI_DICT_ASSIGN_STRING(prosecutor, @"");
		DTAPI_DICT_ASSIGN_STRING(resultIds, @"");
		DTAPI_DICT_ASSIGN_STRING(startIndex, @"");
		DTAPI_DICT_ASSIGN_STRING(status, @"");
		DTAPI_DICT_ASSIGN_STRING(timeStamp, @"");
		DTAPI_DICT_ASSIGN_STRING(title, @"");
		DTAPI_DICT_ASSIGN_STRING(totalRecord, @"");
		DTAPI_DICT_ASSIGN_STRING(url, @"");
		DTAPI_DICT_ASSIGN_STRING(url_hash, @"");
		DTAPI_DICT_ASSIGN_STRING(user_id, @"");
		DTAPI_DICT_ASSIGN_STRING(version, @"");
		DTAPI_DICT_ASSIGN_NUMBER(website_id, @"0");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(appType);
	DTAPI_DICT_EXPORT_BASICTYPE(case_date);
	DTAPI_DICT_EXPORT_BASICTYPE(case_no);
	DTAPI_DICT_EXPORT_BASICTYPE(case_no_hash);
	DTAPI_DICT_EXPORT_BASICTYPE(company_id);
	DTAPI_DICT_EXPORT_BASICTYPE(content);
	DTAPI_DICT_EXPORT_BASICTYPE(create_date);
	DTAPI_DICT_EXPORT_BASICTYPE(create_time);
	DTAPI_DICT_EXPORT_BASICTYPE(createTime);
	DTAPI_DICT_EXPORT_BASICTYPE(credential);
	DTAPI_DICT_EXPORT_BASICTYPE(defendant);
	DTAPI_DICT_EXPORT_BASICTYPE(expertiseId);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(is_analysis);
	DTAPI_DICT_EXPORT_BASICTYPE(is_collection);
	DTAPI_DICT_EXPORT_BASICTYPE(jsonStr);
	DTAPI_DICT_EXPORT_BASICTYPE(lawyerId);
	DTAPI_DICT_EXPORT_BASICTYPE(limitType);
	DTAPI_DICT_EXPORT_BASICTYPE(modify_date);
	DTAPI_DICT_EXPORT_BASICTYPE(org_id);
	DTAPI_DICT_EXPORT_BASICTYPE(pageCount);
	DTAPI_DICT_EXPORT_BASICTYPE(pageNo);
	DTAPI_DICT_EXPORT_BASICTYPE(pageSize);
	DTAPI_DICT_EXPORT_BASICTYPE(pre_stage_case_no);
	DTAPI_DICT_EXPORT_BASICTYPE(pre_stage_case_no_hash);
	DTAPI_DICT_EXPORT_BASICTYPE(prosecutor);
	DTAPI_DICT_EXPORT_BASICTYPE(resultIds);
	DTAPI_DICT_EXPORT_BASICTYPE(startIndex);
	DTAPI_DICT_EXPORT_BASICTYPE(status);
	DTAPI_DICT_EXPORT_BASICTYPE(timeStamp);
	DTAPI_DICT_EXPORT_BASICTYPE(title);
	DTAPI_DICT_EXPORT_BASICTYPE(totalRecord);
	DTAPI_DICT_EXPORT_BASICTYPE(url);
	DTAPI_DICT_EXPORT_BASICTYPE(url_hash);
	DTAPI_DICT_EXPORT_BASICTYPE(user_id);
	DTAPI_DICT_EXPORT_BASICTYPE(version);
	DTAPI_DICT_EXPORT_BASICTYPE(website_id);
    return md;
}
@end
