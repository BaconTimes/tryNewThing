//
//  JYMarkParser.h
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/13.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface JYMarkParser : NSObject

@property (strong, nonatomic) NSString * font;
@property (strong, nonatomic) UIColor * color;
@property (strong, nonatomic) UIColor * strokeColor;
@property (assign, readwrite) float strokeWidth;
@property (strong, nonatomic) NSMutableArray * images;

- (NSAttributedString *)attrStringFromMark:(NSString *)html;

@end
