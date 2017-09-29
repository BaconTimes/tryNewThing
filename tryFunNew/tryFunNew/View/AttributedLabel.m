//
//  AttributedLabel.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/14.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "AttributedLabel.h"
#import <CoreText/CoreText.h>

@implementation AttributedLabel

static inline CGFloat ascentCallBacks(void * ref) {
    return [(NSNumber *)[((__bridge NSDictionary *)ref) valueForKey:@"height"] floatValue];
}

static inline CGFloat descentCallBacks(void * ref) {
    return 0;
}

static inline CGFloat widthCallBacks(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSDate * date = [NSDate date];
    NSTimeInterval time1 = [date timeIntervalSinceNow];
    [self drawViewInRect:rect];
    NSTimeInterval time2 = [date timeIntervalSinceNow];
    NSTimeInterval plus = fabs(time1 - time2);
    NSLog(@"plus = %@", @(plus));
}

- (void)drawViewInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext(); //获取当前绘制上下文--所有的绘制操作都是在上下文进行的
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:@"这里在测试图文混排，\n我是一个富文本"];
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBacks;
    callBacks.getDescent = descentCallBacks;
    callBacks.getWidth = widthCallBacks;
    
    NSDictionary * dicPic = @{@"height": @100, @"width": @100};
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)dicPic);
    unichar placeHolder = 0xFFFC;
    NSString * placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];
    NSMutableAttributedString * placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributeStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    [attributeStr insertAttributedString:placeHolderAttrStr atIndex:12];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attributeStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    NSInteger length = attributeStr.length;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    CTFrameDraw(frame, context);
    UIImage * image = [UIImage imageNamed:@"rainbow.jpg"];
    CGRect imgFrm = [self calculateImageRectWithFrame:frame];
    CGContextDrawImage(context, imgFrm, image.CGImage);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}

- (CGRect)calculateImageRectWithFrame:(CTFrameRef)frame {
    NSArray * arrLines = (NSArray *)CTFrameGetLines(frame);
    NSInteger count = arrLines.count;
    CGPoint points[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    for (int i = 0; i < count; i++) {
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray * arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < arrGlyphRun.count; j++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary * dic = CTRunDelegateGetRefCon(delegate);
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGPoint point = points[i];
            CGFloat ascent;
            CGFloat descent;
            CGRect boundsRun;
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            boundsRun.size.height = ascent + descent;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            boundsRun.origin.x = point.x + xOffset;
            boundsRun.origin.y = point.y - descent;
            CGPathRef path = CTFrameGetPath(frame);
            CGRect colRect = CGPathGetBoundingBox(path);
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            return imageBounds;
            
        }
    }
    return CGRectZero;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)ClickOnStrWithPoint:(CGPoint)location
{
    CTFrameRef ctFrame;
#warning wrong
    NSArray * lines = (NSArray *)CTFrameGetLines(ctFrame);
    CFRange ranges[lines.count];
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    for (int i = 0; i < lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CFRange range = CTLineGetStringRange(line);
        ranges[i] = range;
    }
}

- (CGPoint)systemPointFromScreenPoint:(CGPoint)origin {
    return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}

- (BOOL)isIndex:(NSInteger)index inRange:(NSRange)range
{
    return (index <= range.location + range.length - 1) && (index >= range.location);
}

- (BOOL)isFrame:(CGRect)frame containsPoints:(CGPoint)point{
    return CGRectContainsPoint(frame, point);
}

- (CGRect)frameForCTRunWithIndex:(NSInteger)index CTLine:(CTLineRef)line origin:(CGPoint)origin
{
    CGFloat offsetX = CTLineGetOffsetForStringIndex(line, index, NULL);
    CGFloat offsexX2 = CTLineGetOffsetForStringIndex(line, index + 1, NULL);
    offsetX += origin.x;
    offsexX2 += origin.x;
    CGFloat offsetY = origin.y;
    CGFloat lineAscent;
    CGFloat lineDescent;
    NSArray * runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
    CTRunRef runCurrent;
    for (int k = 0; k < runs.count; k++) {
        CTRunRef run = (__bridge CTRunRef)runs[k];
        CFRange range = CTRunGetStringRange(run);
        NSRange rangeOC = NSMakeRange(range.location, range.length);
        if ([self isIndex:index inRange:rangeOC]) {
            runCurrent = run;
            break;
        }
    }
    CTRunGetTypographicBounds(runCurrent, CFRangeMake(0, 0), &lineAscent, &lineDescent, NULL);
    CGFloat height = lineAscent + lineDescent;
    return CGRectMake(offsetX, offsetY, offsexX2 - offsetX, height);
}

@end
