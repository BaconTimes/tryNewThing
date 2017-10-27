//
//  GlodModel.h
//  tryFunNew
//
//  Created by iOSBacon on 2017/9/29.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlodModel : NSObject<YYModel>

@property (nonatomic, copy) NSString * targetId;

@property (nonatomic, assign) double height;

@property (nonatomic, assign) double width;

@property (nonatomic, assign) double weight;

@property (nonatomic, copy) NSString * name;

- (void)printRect;

@end
