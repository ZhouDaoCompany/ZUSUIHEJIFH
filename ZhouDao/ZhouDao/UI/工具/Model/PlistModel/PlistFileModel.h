//
//  file.h
//  周道
//
//  Created by _author on 16-11-10.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface PlistFileModel : NSObject {
	NSString *_address;
	NSString *_name;
	NSString *_version;
    //社保
    NSString *_up;
    NSString *_down;
    NSString *_gr_ratio;
    NSString *_gs_ratio;
}


@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *up;
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *gr_ratio;
@property (nonatomic, copy) NSString *gs_ratio;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 
