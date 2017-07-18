
//
//  CTView.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/6/23.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>

@implementation CTView

- (void)drawRect1:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGMutablePathRef path = CGPathCreateMutable();//1
    
    CGPathAddRect(path, NULL, self.bounds);
    
    NSAttributedString * attString = [[NSAttributedString alloc] initWithString:@"Hello core text world!"];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, NULL);
    CTFrameDraw(frame, context);
    
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ref, CGAffineTransformIdentity);
    CGContextTranslateCTM(ref, 0, rect.size.height);
    CGContextScaleCTM(ref, 1, -1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, self.bounds);
    NSAttributedString * attString = [[NSAttributedString alloc] initWithString:@"Teacher chang! "];
    CTFramesetterRef framesettr = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesettr, CFRangeMake(0, attString.length), path, NULL);
    CTFrameDraw(frame, ref);
    CFRelease(framesettr);
    CFRelease(path);
    CFRelease(frame);
}

+ (void)ctu_drawAttributedText:(NSAttributedString *)attributedText textRange:(NSRange)textRange inRect:(CGRect)rect context:(CGContextRef)context{
    NSAssert(context != NULL, @"context is NULL !");
    if (context == NULL ||
        attributedText == nil||
        attributedText.length == 0||
        CGRectIsEmpty(rect) ||
        textRange.length == 0) return;
    /*Push a copy of the current graphics state onto graphics state stack. */
    CGContextSaveGState(context);
    {
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGContextScaleCTM(context, 1, -1);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText);
        CGRect _rect = CGRectMake(0, 0, rect.size.width, rect.size.height);
        
        CGPathRef path = CGPathCreateWithRect(_rect, nil);
        
        CFRange _textRange = CFRangeMake(textRange.location, textRange.length);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, _textRange, path, nil);
        CTFrameDraw(frame, context);
        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);
    }
    CGContextRestoreGState(context);
}

@end
