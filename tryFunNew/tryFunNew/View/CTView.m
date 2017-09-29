
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

void printRectArray(CGRect * rect, int count) {
    NSLog(@"start printRectArray function ");
    for (int i = 0; i < count; i++) {
        CGRect tmpRect = rect[i];
        NSLog(@"tmpRect = %@", NSStringFromCGRect(tmpRect));
        
    }
    NSLog(@"end printRectArray print");
}

NSAttributedString * applyParaStyle(CFStringRef fontName, CGFloat pointSize, NSString * plaintText, CGFloat lineSpaceInc){
    CTFontRef font = CTFontCreateWithName(fontName, pointSize, NULL);
    
    CGFloat lineSpacing = (CTFontGetLeading(font) + lineSpaceInc) * 2;
    
    CTParagraphStyleSetting setting;
    setting.spec = kCTParagraphStyleSpecifierLineSpacing;
    setting.valueSize = sizeof(CGFloat);
    setting.value = &lineSpacing;
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(&setting, 1);
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font, (id)kCTFontNameAttribute, (__bridge id)paragraphStyle, (id)kCTParagraphStyleAttributeName, nil];
    CFRelease(font);
    CFRelease(paragraphStyle);
    
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:plaintText attributes:attributes];
    return attrString;
}

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

- (void)drawRect2:(CGRect)rect {
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


- (void)drawRect3:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect bounds = CGRectMake(10, 10, 300, 200);
    CGPathAddRect(path, NULL, bounds);
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextFillRect(context, bounds);
    
    CFStringRef textString = CFSTR("Hello, World! World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), textString);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {1, 0, 0, 0.8};
    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);
    CFIndex length = CFAttributedStringGetLength(attrString);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 12), kCTForegroundColorAttributeName, red);
    CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 24, NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, length), kCTFontAttributeName, font);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    
    CTFrameDraw(frame, context);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawViewInRect:rect context:context];
}

- (CFArrayRef)createColumnsWithColumnCount:(int)columnCount {
    int column;
    CGRect * columnRects = (CGRect *)calloc(columnCount, sizeof(*columnRects));
    columnRects[0] = self.bounds;
    
    CGFloat columnWidth = CGRectGetWidth(self.bounds) / columnCount;
    //将columnRect的
    for (column = 0; column < columnCount - 1; column ++) {
        printRectArray(columnRects, columnCount);
        CGRectDivide(columnRects[column], &columnRects[column], &columnRects[column + 1], columnWidth, CGRectMinXEdge);
    }
    printRectArray(columnRects, columnCount);

    for (column = 0; column < columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column], 8, 15);
        printRectArray(columnRects, columnCount);
    }
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, columnCount, &kCFTypeArrayCallBacks);
    for (column = 0; column < columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        CFArrayInsertValueAtIndex(array, column, path);
//        CGRect rect1 = CGPathGetBoundingBox(path);
//        CGRect rect2 = CGPathGetPathBoundingBox(path);
//        NSLog(@"rect1 = %@", NSStringFromCGRect(rect1));
//        NSLog(@"rect2 = %@", NSStringFromCGRect(rect2));

        CFRelease(path);
    }
    free(columnRects);
    return array;
}

- (UIImage *)startDraw {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawViewInRect:self.frame context:context];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

- (void)drawViewInRect:(CGRect)rect context:(CGContextRef)context {
    CFStringRef string = CFSTR("Hello, World! World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.In Core Text, you usually don't need to do manual line breaking unless you have a special hyphenation process or a similar requirement. A framesetter performs line breaking automatically. Alternatively, Core Text enables you to specify exactly where you want each line of text to break. Listing 2-5 shows how to create a typesetter, an object used by the framesetter, and use the typesetter directly to find appropriate line breaks and create a typeset line manually. This sample also shows how to center a line before drawin");
    CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 24, NULL);;
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextFillRect(context, rect);
    CFStringRef keys[] = {kCTFontAttributeName};
    CFTypeRef values[] = {font};
    
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys, (const void **)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFArrayRef columnsPaths = [self createColumnsWithColumnCount:3];
    CFIndex pathCount = CFArrayGetCount(columnsPaths);
    CFIndex startIndex = 0;
    int column;
    NSArray<UIColor *> * colorArray = @[[UIColor purpleColor], [UIColor yellowColor], [UIColor brownColor], [UIColor redColor], [UIColor orangeColor], [UIColor greenColor], [UIColor purpleColor]];
    for (column = 0; column < pathCount; column++) {
        CGPathRef path = (CGPathRef)CFArrayGetValueAtIndex(columnsPaths, column);
        
        CGRect rect1 = CGPathGetBoundingBox(path);
        CGColorRef color = colorArray[column].CGColor;
        CGContextSetFillColorWithColor(context, color);
        CGContextFillRect(context, rect1);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    CFRelease(columnsPaths);
    CFRelease(framesetter);
}

@end
