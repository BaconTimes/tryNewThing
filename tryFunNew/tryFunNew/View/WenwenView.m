//
//  WenwenView.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/8/3.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "WenwenView.h"

@implementation WenwenView

- (void)setText:(NSString *)text {
    _text = text;
    NSMutableAttributedString * muAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [muAttributedString addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, text.length)];
    [muAttributedString addAttribute:NSForegroundColorAttributeName value:_textColor range:NSMakeRange(0, text.length)];
    
}

@end
