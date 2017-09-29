//
//  UIImage+localImage.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/9/8.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "UIImage+localImage.h"

@implementation UIImage (localImage)

+ (UIImage *)imageFileOfName:(NSString *)imageName {
    NSString * imgPath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    if (imgPath == nil) {
        for (NSBundle * bundle in [NSBundle allBundles]) {
            imgPath = [bundle pathForResource:imageName ofType:nil];
            if (imgPath != nil) break;
        }
    }
    return [UIImage imageWithContentsOfFile:imgPath];
}

@end
