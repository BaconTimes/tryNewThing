//
//  TouchView.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/10/26.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s %@",__FUNCTION__, NSStringFromCGPoint([touches.anyObject locationInView:self]));
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSLog(@"%s %@",__FUNCTION__, NSStringFromCGPoint([touches.anyObject locationInView:self]));
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s %@",__FUNCTION__, NSStringFromCGPoint([touches.anyObject locationInView:self]));
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"%s %@",__FUNCTION__, NSStringFromCGPoint([touches.anyObject locationInView:self]));
}

@end
