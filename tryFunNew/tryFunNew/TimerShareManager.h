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

@property (nonatomic, assign, readonly) NSUInteger leftCount;

@property (nonatomic, weak) id <TimerShareManagerDelegate> timerDelegate;

+ (instancetype)sharedInstance;

- (BOOL)createTimerWithTimerType:(NXTimerType)timerType totalTime:(NSUInteger)totalTime timeInterval:(NSUInteger)interval;
//
//- (BOOL)isExistTimer;
//
//- (void)invalidateTimer;

@end
