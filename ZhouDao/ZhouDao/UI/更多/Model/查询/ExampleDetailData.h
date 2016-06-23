//
//  data.h
//  周道
//
//  Created by _author on 16-05-12.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface ExampleDetailData : NSObject
{
	NSString *_appType;
	NSString *_case_date;
	NSString *_case_no;
	NSString *_case_no_hash;
	NSString *_company_id;
	NSString *_content;
	NSString *_create_date;
	NSNumber *_create_time;
	NSString *_createTime;
	NSString *_credential;
	NSString *_defendant;
	NSString *_expertiseId;
	NSString *_id;
	NSNumber *_is_analysis;
	NSNumber *_is_collection;
	NSString *_jsonStr;
	NSString *_lawyerId;
	NSString *_limitType;
	NSString *_modify_date;
	NSString *_org_id;
	NSString *_pageCount;
	NSNumber *_pageNo;
	NSNumber *_pageSize;
	NSString *_pre_stage_case_no;
	NSString *_pre_stage_case_no_hash;
	NSString *_prosecutor;
	NSString *_resultIds;
	NSString *_startIndex;
	NSString *_status;
	NSString *_timeStamp;
	NSString *_title;
	NSString *_totalRecord;
	NSString *_url;
	NSString *_url_hash;
	NSString *_user_id;
	NSString *_version;
	NSNumber *_website_id;
}


@property (nonatomic, copy) NSString *appType;
@property (nonatomic, copy) NSString *case_date;
@property (nonatomic, copy) NSString *case_no;
@property (nonatomic, copy) NSString *case_no_hash;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic, copy) NSNumber *create_time;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *credential;
@property (nonatomic, copy) NSString *defendant;
@property (nonatomic, copy) NSString *expertiseId;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSNumber *is_analysis;
@property (nonatomic, copy) NSNumber *is_collection;
@property (nonatomic, copy) NSString *jsonStr;
@property (nonatomic, copy) NSString *lawyerId;
@property (nonatomic, copy) NSString *limitType;
@property (nonatomic, copy) NSString *modify_date;
@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, copy) NSNumber *pageNo;
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSString *pre_stage_case_no;
@property (nonatomic, copy) NSString *pre_stage_case_no_hash;
@property (nonatomic, copy) NSString *prosecutor;
@property (nonatomic, copy) NSString *resultIds;
@property (nonatomic, copy) NSString *startIndex;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *totalRecord;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *url_hash;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSNumber *website_id;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 