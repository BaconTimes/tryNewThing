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

- (BOOL)isExistTimer {
    if (_typeKey.length > 0 && _currentTimerType != 0) {
        return [[_muDict objectForKey:@(_currentTimerType)] objectForKey:_typeKey] != nil;
    } else {
        return NO;
    }
}

- (NSUInteger)leftCount {
    if (self.isExistTimer) {
        NSDictionary * tmpMuDict = [[_muDict objectForKey:@(_currentTimerType)] objectForKey:_typeKey];
        return [[tmpMuDict objectForKey:_timerCountKey] unsignedLongValue];
    } else {
        return 0;
    }
}

- (BOOL)createTimerWithTimerType:(NXTimerType)timerType typeKey:(NSString *)typeKey totalTime:(NSUInteger)totalTime timeInterval:(NSUInteger)interval{
    _currentTimerType = timerType;
    _typeKey = typeKey;
    if (_typeKey.length > 0 && _currentTimerType != 0) {
        if (self.isExistTimer) {
            return YES;
        } else {
            NSTimer * nxTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timeRoll:) userInfo:nil repeats:YES];
            NSMutableDictionary * tmpMuDict_2 = [NSMutableDictionary new];
            NSMutableDictionary * tmpMuDict_3 = [NSMutableDictionary new];
            [tmpMuDict_3 setObject:@(totalTime) forKey:_timerCountKey];
            [tmpMuDict_3 setObject:nxTimer forKey:_timerKey];
            [tmpMuDict_2 setObject:tmpMuDict_3 forKey:typeKey];
            [_muDict setObject:tmpMuDict_2 forKey:@(timerType)];
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)timeRoll:(NSTimer *)paraTimer {
    NSMutableDictionary * tmpMuDict_2 = [_muDict objectForKey:@(_currentTimerType)];
    NSMutableDictionary * tmpMuDict_3 = [tmpMuDict_2 objectForKey:_typeKey];
    NSUInteger leftCount = [[tmpMuDict_3 objectForKey:_timerCountKey] unsignedLongValue];
    if (leftCount == 1) {
        [paraTimer invalidate];
    }
    {
        leftCount --;
        [tmpMuDict_3 setObject:@(leftCount) forKey:_timerCountKey];
        [tmpMuDict_2 setObject:tmpMuDict_3 forKey:_typeKey];
        [_muDict setObject:tmpMuDict_2 forKey:@(_currentTimerType)];
    }
    if (leftCount == 0) {
        [paraTimer invalidate];
        [tmpMuDict_3 removeAllObjects];
        [tmpMuDict_2 removeObjectForKey:_typeKey];
        paraTimer = nil;
        [_muDict removeObjectForKey:@(_currentTimerType)];
    }
    if ([self.timerDelegate respondsToSelector:@selector(timerWithLeftCount:)]) {
        [self.timerDelegate timerWithLeftCount:leftCount];
    }
    NSLog(@"%s --- leftCount = %lu", __FUNCTION__, (unsigned long)leftCount);
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
