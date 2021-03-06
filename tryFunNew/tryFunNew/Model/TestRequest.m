//
//  TestRequest.m
//  OAConnectStore
//
//  Created by iOSBacon on 2017/9/22.
//  Copyright © 2017年 Nxin.com. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest

+ (id)getDataWithKey:(NSString *)key {
    
#if TARGET_OS_SIMULATOR
    NSString * netUrl = @"http://127.0.0.1:5000";
#else
    NSString * netUrl = @"http://10.100.23.49:5000";
#endif

    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",netUrl, key]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:3];
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        NSLog(@"sendSynchronousRequest error = %@",error);
    }
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"NSJSONSerialization error = %@",error);
    }
    return obj;
}

@end
