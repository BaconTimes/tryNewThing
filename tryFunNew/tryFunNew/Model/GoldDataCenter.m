//
//  GoldDataCenter.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/9/29.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "GoldDataCenter.h"

@implementation GoldDataCenter

+(void)insertGold:(GlodModel *)glodModel {
    if (!glodModel.targetId) return;
    Gold * gold = [Gold MR_findFirstOrCreateByAttribute:@"targetId" withValue:glodModel.targetId];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        [self configureEntity:gold withModel:glodModel];
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

@end
