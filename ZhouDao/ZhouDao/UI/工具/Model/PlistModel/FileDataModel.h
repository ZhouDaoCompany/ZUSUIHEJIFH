//
//  data.h
//  周道
//
//  Created by _author on 16-11-10.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
@class PlistFileModel;


@interface FileDataModel : NSObject
{
	NSMutableArray *_file;
	NSString *_txt;
}


@property (nonatomic, retain) NSMutableArray *file;
@property (nonatomic, copy) NSString *txt;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 
