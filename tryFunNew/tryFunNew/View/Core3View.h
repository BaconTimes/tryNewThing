//
//  Core3View.h
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/22.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HFDrawPureText,
    HFDrawTextAndPicture,
    HFDrawTextLineByLine,
    HFDrawTextLineByLineAlignment,
} HFDrawType;

@interface Core3View : UIView

@property (nonatomic, assign) HFDrawType drawType;

@property (nonatomic, copy) NSString * text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) CGFloat textHeight;

@end
