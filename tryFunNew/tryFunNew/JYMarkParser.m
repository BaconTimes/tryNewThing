//
//  JYMarkParser.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/13.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "JYMarkParser.h"

@implementation JYMarkParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        _font = @"Arial";
        _color = [UIColor blackColor];
        _strokeColor = [UIColor whiteColor];
        _strokeWidth = 0.0;
        _images = [NSMutableArray array];
    }
    return self;
}

- (NSAttributedString *)attrStringFromMark:(NSString *)markup {
    NSMutableAttributedString * aString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSError * error = nil;
    
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators;
    NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern:@"(.*?)(<[^>]+>|\\Z)" options:options error:&error];
    
    NSArray * chunks = [regex matchesInString:markup options:0 range:NSMakeRange(0, markup.length)];
    if (error) {
        NSLog(@"解析标签出现错误: %@\n%@", [error userInfo], error);
        return [[NSAttributedString alloc] initWithString:markup];
    }
    for (NSTextCheckingResult* result in chunks) {
        NSArray* parts = [[markup substringWithRange:result.range] componentsSeparatedByString:@"<"];
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font, 24.0f, NULL);
        NSDictionary * attrs = @{(id)kCTForegroundColorAttributeName: (id)_color.CGColor,
                                 (id)kCTFontAttributeName: (__bridge id)fontRef,
                                 (id)kCTStrokeColorAttributeName: (__bridge id)self.strokeColor.CGColor,
                                 (id)kCTStrokeWidthAttributeName: @(_strokeWidth)};
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:parts[0] attributes:attrs]];
        CFRelease(fontRef);
        
        if (parts.count > 1) {
            NSString * tag = parts[1];
            if ([tag hasPrefix:@"font"]) {
                NSRegularExpression * scReg = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:nil];
                [scReg enumerateMatchesInString:tag options:0 range:NSMakeRange(0, tag.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    if ([[tag substringWithRange:result.range] isEqualToString:@"none"]) {
                        _strokeWidth = 0;
                    }
                    else {
                        _strokeWidth = -3;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", [tag substringWithRange:result.range]]);
                        _strokeColor = [[UIColor new] performSelector:colorSel];
                    }
                }];
            }
        }
    }
    return nil;
}

-(void)dealloc {
    _font = nil;
    _color = nil;
    _strokeColor = nil;
    _images = nil;
}

@end
