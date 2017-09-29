//
//  EmojiManager.h
//  VVeboTableViewDemo
//
//  Created by iOSBacon on 2017/7/28.
//  Copyright © 2017年 Johnil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary * emojiDict;

+ (instancetype)shareEmojiManager;

@end
