//
//  GoldDataCenter.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/9/29.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "GoldDataCenter.h"

@implementation GoldDataCenter{
    NSManagedObjectContext * _mainThreadContext;
    NSManagedObjectContext * _backgroundObjectContext;
    NSPersistentStoreCoordinator * _storeCoordinator;
}

+(void)insertGold:(GlodModel *)glodModel {
    if (!glodModel.targetId) return;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        Gold * gold = [Gold MR_findFirstOrCreateByAttribute:@"targetId" withValue:glodModel.targetId inContext:localContext];
        [self configureEntity:gold withModel:glodModel];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        NSLog(@"[Gold MR_countOfEntities] = %@", @([Gold MR_countOfEntities]));
    }];
}

+ (void)insertGolds:(NSArray<GlodModel *> *)goldArray {
    if (goldArray.count == 0) return;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (GlodModel * gModel in goldArray) {
            Gold * gold = [Gold MR_findFirstOrCreateByAttribute:@"targetId" withValue:gModel.targetId inContext:localContext];
            [self configureEntity:gold withModel:gModel];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        NSLog(@"%s",__FUNCTION__);
    }];
}

+ (void)deleteGold:(GlodModel *)glodModel {
    if (!glodModel.targetId) return;
    Gold * gold = [Gold MR_findFirstByAttribute:@"targetId" withValue:glodModel.targetId];
    if (gold) {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            [gold MR_deleteEntity];
        }];
    }
}

+ (void)updateGlod:(GlodModel *)glodModel {
    if (!glodModel.targetId) return;
    Gold * gold = [Gold MR_findFirstByAttribute:@"targetId" withValue:glodModel.targetId];
    if (gold) {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            [self configureEntity:gold withModel:glodModel];
        }];
    }
}

+ (void)configureEntity:(Gold *)entity withModel:(GlodModel *)goldModel {
    if (entity && goldModel) {
        entity.targetId = goldModel.targetId;
        entity.name = goldModel.name;
        entity.width = goldModel.width;
        entity.height = goldModel.height;
        entity.weight = goldModel.weight;
    }
}

+ (GlodModel *)modelWithEntity:(Gold *)gold {
    if (gold) {
        GlodModel * model = [GlodModel new];
        model.targetId = gold.targetId;
        model.width = gold.width;
        model.height = gold.height;
        model.name = gold.name;
        model.weight = gold.weight;
        return model;
    }
    return nil;
}

+ (void)save {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            NSLog(@"%s",__FUNCTION__);
        }
    }];
}

+ (void)saveAndWait {
    [[NSManagedObjectContext MR_context] MR_saveToPersistentStoreAndWait];
}

@end
