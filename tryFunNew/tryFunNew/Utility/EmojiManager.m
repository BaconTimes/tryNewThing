//
//  EmojiManager.m
//  VVeboTableViewDemo
//
//  Created by iOSBacon on 2017/7/28.
//  Copyright © 2017年 Johnil. All rights reserved.
//

#import "EmojiManager.h"

static EmojiManager * _manager;

@implementation EmojiManager {
}

+ (instancetype)shareEmojiManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[EmojiManager alloc] init];
        NSString * pathString = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
        NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:pathString];
        _manager->_emojiDict = dict;
    });
    return _manager;
}



@end
