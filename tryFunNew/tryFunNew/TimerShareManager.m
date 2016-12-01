//
//  TimerShareManager.m
//  OAConnectStore
//
//  Created by iOSBacon on 2016/12/1.
//  Copyright © 2016年 zengxiangrong. All rights reserved.
//

#import "TimerShareManager.h"

NSString const * _timerKey = @"timerKey";
NSString const * _timerCountKey = @"timerCountKey";

static TimerShareManager * _instance;

@interface TimerShareManager ()

@property (nonatomic, strong) NSMutableDictionary * muDict;

@end

@implementation TimerShareManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}    

- (NSTimer *)getTimerWithTimerType:(NXTimerType)timerType {
    NSDictionary * dict = [_muDict objectForKey:@(timerType)];
    if (dict != nil) {
        return [dict objectForKey:_timerKey];
    } else {
        return nil;
    }
}

- (BOOL)isExistTimer {
    return [self isExistTimerWithTimerType:_currentTimerType];
}

- (BOOL)isExistTimerWithTimerType:(NXTimerType)timerType {
    return [self getTimerWithTimerType:timerType] != nil;
}

- (NSUInteger)leftCount {
    NSMutableDictionary * tmpMuDict = [_muDict objectForKey:@(self.currentTimerType)];
    if (tmpMuDict != nil) {
        return [[tmpMuDict objectForKey:_timerCountKey] unsignedLongValue];
    } else {
        return 0;
    }
}

- (BOOL)createTimerWithTimerType:(NXTimerType)timerType typeKey:(NSString *)typeKey totalTime:(NSUInteger)totalTime timeInterval:(NSUInteger)interval{
    self.currentTimerType = timerType;
    if ([self isExistTimerWithTimerType:timerType]) {
        return YES;
    } else {
        NSTimer * nxTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timeRoll:) userInfo:nil repeats:YES];
        NSMutableDictionary * tmpMuDict = [NSMutableDictionary new];
        [tmpMuDict setObject:@(totalTime) forKey:_timerCountKey];
        [tmpMuDict setObject:nxTimer forKey:_timerKey];
        [_muDict setObject:tmpMuDict forKey:@(timerType)];
    }
    return YES;
}

- (void)timeRoll:(NSTimer *)paraTimer {
    NSMutableDictionary * tmpMuDict = [_muDict objectForKey:@(self.currentTimerType)];
    NSUInteger leftCount = [[tmpMuDict objectForKey:_timerCountKey] unsignedLongValue];
    if (leftCount == 1) {
        [paraTimer invalidate];
    }
    if (leftCount == 0) {
        [paraTimer invalidate];
        [tmpMuDict removeAllObjects];
        paraTimer = nil;
        [_muDict removeObjectForKey:@(_currentTimerType)];
    } else {
        leftCount --;
        [tmpMuDict setObject:@(leftCount) forKey:_timerCountKey];
        [_muDict setObject:tmpMuDict forKey:@(_currentTimerType)];
    }
    if ([self.timerDelegate respondsToSelector:@selector(timerWithLeftCount:)]) {
        [self.timerDelegate timerWithLeftCount:leftCount];
    }
    NSLog(@"%s --- leftCount = %lu",__FUNCTION__, (unsigned long)leftCount);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _muDict = [NSMutableDictionary new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
@end
