//
//  AttributedView.h
//  tryFunNew
//
//  Created by iOSBacon on 2017/8/1.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributedView : UIView

@property (nonatomic, strong) id text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) NSInteger lineSpace;
@property (nonatomic) NSTextAlignment textAlignment;

@end
