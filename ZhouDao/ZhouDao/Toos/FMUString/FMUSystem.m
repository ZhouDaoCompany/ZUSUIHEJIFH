//
//  FMUSystem.m
//  FMLibrary
//
//  Created by leks on 13-4-24.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import "FMUSystem.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@implementation FMUSystem

+(NSString*)systemVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+(CGFloat)versionFloatValue:(NSString*)versionString
{
    NSArray *tmp = [versionString componentsSeparatedByString:@"."];
    if (tmp.count == 0) {
        return 0;
    }
    
    CGFloat version = [[tmp objectAtIndex:0] floatValue];
    
    NSUInteger i=1;
    CGFloat pow = 1;
    
    while (i < tmp.count)
    {
        NSString *s = [tmp objectAtIndex:i];
        pow *= powf(10, s.length);
        version += s.floatValue / pow;
        i++;
    }
    
    return version;
}

+(CGFloat)systemVersionFloat
{
    NSString *version_str = [FMUSystem systemVersion];
    return [FMUSystem versionFloatValue:version_str];
}

+ (NSString *) macAddress
{
    static NSMutableString *MAC_ADDRESS = nil;
    
    if (MAC_ADDRESS) {
        return MAC_ADDRESS;
    }
    
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%x%x%x%x%x%x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    if (outstring)
    {
        MAC_ADDRESS = [NSMutableString stringWithCapacity:10];
        [MAC_ADDRESS setString:[outstring uppercaseString]];
    }
    
    return MAC_ADDRESS;
}

+ (NSString *)getDeviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machine;
}

//获取设备操作系统版本
+ (CGFloat)getOSVersion
{
    NSString *value = [[UIDevice currentDevice]systemVersion];
    return [self versionFloatValue:value];
}

+ (BOOL)isIpad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIphone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

@end
