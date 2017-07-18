//
//  CoreTextV.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/15.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "CoreTextV.h"
#import <CoreText/CoreText.h>

@implementation CoreTextV{
    CTFrameRef _frame;
    NSInteger _length;
    CGRect _imgFrm;
    NSMutableArray * arrText;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    arrText = [NSMutableArray array];
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributeStr.length)];
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBacks;
    callBacks.getWidth = widthCallBacks;
    callBacks.getDescent = descentCallBacks;
    NSDictionary * dicPic = @{@"height":@90,@"width":@160};
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)dicPic);
    unichar placeHolder = 0xFFFC;
    NSString * placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];
    NSMutableAttributedString * placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    [attributeStr insertAttributedString:placeHolderAttrStr atIndex:300];
    NSDictionary * activeAttr = @{NSForegroundColorAttributeName: [UIColor redColor], @"click": NSStringFromSelector(@selector(click))};
    [attributeStr addAttributes:activeAttr range:NSMakeRange(100, 30)];
    [attributeStr addAttributes:activeAttr range:NSMakeRange(400, 100)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath * cirP = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 200)];
    [path appendPath:cirP];
    _length = attributeStr.length;
    _frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, _length), path.CGPath, NULL);
    CTFrameDraw(_frame, context);
    
    UIImage * image = [UIImage imageNamed:@"rainbow.jpg"];
    [self handleActiveRectWithFrame:_frame];
    CGContextDrawImage(context, _imgFrm, image.CGImage);
    
//    CGContextDrawImage(context, cirP.bounds, [image dw_])
    CFRelease(_frame);
    CFRelease(frameSetter);
}

- (void)handleActiveRectWithFrame:(CTFrameRef)frame {
    NSArray * arrLines = (NSArray *)CTFrameGetLines(frame);
    NSInteger count = [arrLines count];
    CGPoint points[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    for (int i = 0; i < count; i++) {
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray * arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < arrGlyphRun.count; j++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            CGPoint point = points[i];
            if (delegate == nil) {
                NSString * string = attributes[@"click"];
                if (string != nil) {
                    [arrText addObject:[NSValue valueWithCGRect:[self getLocWithFrame:frame CTLine:line CTRun:run origin:point]]];
                }
                continue;
            }
            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            _imgFrm = [self getLocWithFrame:frame CTLine:line CTRun:run origin:point];
        }
    }
}

- (CGRect)getLocWithFrame:(CTFrameRef)frame CTLine:(CTLineRef)line CTRun:(CTRunRef)run origin:(CGPoint)origin {
    CGFloat ascent;
    CGFloat descent;
    CGRect boundsRun;
    boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
    boundsRun.size.height = ascent + descent;
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    boundsRun.origin.x = origin.x + xOffset;
    boundsRun.origin.y = origin.y - descent;
    CGPathRef path = CTFrameGetPath(frame);
    CGRect colRect = CGPathGetBoundingBox(path);
    CGRect deleteBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
    return deleteBounds;
}

- (CGRect)convertRectFromLoc:(CGRect)rect {
    return CGRectMake(rect.origin.x, self.bounds.size.height - rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGRect imageFrmToScreen = [self convertRectFromLoc:_imgFrm];
    if (CGRectContainsPoint(imageFrmToScreen, location)) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"你点击了图片" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        return;
    }
    [arrText enumerateObjectsUsingBlock:^(NSValue * rectV, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textFrmToScreen = [self convertRectFromLoc:[rectV CGRectValue]];
        if (CGRectContainsPoint(textFrmToScreen, location)) {
            [self click];
            *stop = YES;
        }
    }];
}

- (void)click{
    [[[UIAlertView alloc] initWithTitle:nil message:@"你点击了文字" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
}

static CGFloat ascentCallBacks(void * ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallBacks(void * ref) {
    return 0;
}

static CGFloat widthCallBacks(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}
@end
