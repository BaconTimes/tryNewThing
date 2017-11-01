//
//  MRCTest.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/10/30.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "MRCTest.h"

@implementation MRCTest

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.obj1 = [[[NSObject alloc] init] retain];
        NSLog(@"%lu", [[NSObject alloc] init].retainCount);
    }
    return self;
}

@end
