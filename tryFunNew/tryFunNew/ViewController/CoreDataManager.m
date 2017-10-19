//
//  CoreDataManager.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/10/19.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager()

@property (nonatomic, strong) NSManagedObjectContext * mainContext;

@property (nonatomic, strong) NSManagedObjectContext * backgroundContext;

@end

@implementation CoreDataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setContext];
    }
    return self;
}

- (void)setContext {
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [NSManagedObjectContext MR_newMainQueueContext];
    [NSManagedObjectContext MR_newPrivateQueueContext];
}

@end
