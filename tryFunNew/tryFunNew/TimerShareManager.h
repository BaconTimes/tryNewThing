//
//  TimerShareManager.h
//  OAConnectStore
//
//  Created by iOSBacon on 2016/12/1.
//  Copyright © 2016年 zengxiangrong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    NXTimerTypeRegister = 1,
    NXTimerTypeFindPsd,
    NXTimerTypeEngBind,
} NXTimerType;

@protocol TimerShareManagerDelegate <NSObject>

- (void)timerWithLeftCount:(NSUInteger)interval;

@end

@interface TimerShareManager : NSObject

@property (nonatomic, assign) NXTimerType currentTimerType;

@property (nonatomic, copy) NSString * typeKey;

@property (nonatomic, weak) id <TimerShareManagerDelegate> timerDelegate;

//当前剩余的倒计时
@property (nonatomic, assign, readonly) NSUInteger leftCount;

//是否存在倒计时
@property (nonatomic, assign, readonly) BOOL isExistTimer;

+ (instancetype)sharedInstance;

/*
 @para timerType 时间类型，可以在上面的枚举中添加
 @para typeKey 类型的key
 @para totalTime 倒计时的总时间
 @para timeInterval 倒计时的时间间隔
 */
- (BOOL)createTimerWithTimerType:(NXTimerType)timerType
                         typeKey:(NSString *)typeKey
                       totalTime:(NSUInteger)totalTime
                    timeInterval:(NSUInteger)interval;

@end
