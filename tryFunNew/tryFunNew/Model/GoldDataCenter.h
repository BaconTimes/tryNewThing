//
//  GoldDataCenter.h
//  tryFunNew
//
//  Created by iOSBacon on 2017/9/29.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gold+CoreDataClass.h"
#import "GlodModel.h"

@interface GoldDataCenter : NSObject

+ (void)insertGold:(GlodModel *)glodModel;

+ (void)deleteGold:(GlodModel *)glodModel;

+ (void)updateGlod:(GlodModel *)glodModel;

@end
