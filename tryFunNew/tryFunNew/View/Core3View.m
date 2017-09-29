//
//  Core3View.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/22.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "Core3View.h"
#import <CoreText/CoreText.h>

//行距
const CGFloat kGlobalLineLeading = 5.0;

// 在15字体下，比值小于这个计算出来的高度会导致emoji显示不全
const CGFloat kPerLineRatio = 1.4;

@implementation Core3View

+ (CGFloat)textHeightWithText:(NSString *)aText width:(CGFloat)aWidth font:(UIFont *)aFont type:(HFDrawType) drawType{
    CGFloat height = 0;
    switch (drawType) {
        case HFDrawPureText:
            height = 400;
            break;
        case HFDrawTextAndPicture:
            height = 400 * 3;
            break;
        case HFDrawTextLineByLine:
            height = [self textHeightWidthText3:aText width:aWidth font:aFont];
            break;
        case HFDrawTextLineByLineAlignment:
            height = [self textHeightWithText2:aText width:aWidth font:aFont];
        default:
            height = 0;
            break;
    }
    return height;
}

+ (CGFloat)textHeightWithText2:(NSString *)aText width:(CGFloat)aWidth font:(UIFont *)aFont {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:aText];
    [self addGlobalAttributeWithContent:content font:aFont];
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)content);
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, aText.length), NULL, CGSizeMake(aWidth, MAXFLOAT), NULL);
    NSLog(@"suggestHeight = %f",suggestSize.height);

    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, aWidth, suggestSize.height));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, content.length), pathRef, NULL);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    NSLog(@"行数 = %ld",lineCount);
    
    CGFloat accurateHeight = lineCount * (aFont.pointSize * kPerLineRatio);
    CGFloat height = accurateHeight;
    CFRelease(pathRef);
    CFRelease(frameRef);
    return height;
}

+ (CGFloat)textHeightWidthText3:(NSString *)aText width:(CGFloat)aWidth font:(UIFont *)aFont {
    NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:aText];
    [self addGlobalAttributeWithContent:content font:aFont];
    
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, aText.length), NULL, CGSizeMake(aWidth, MAXFLOAT), NULL);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, aWidth, suggestSize.height * 10));
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, aText.length), path, NULL);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    CGFloat totalHeight = 0;
    NSLog(@"计算高度开始");
    for (CFIndex i = 0; i < lineCount; i++) {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, i);
        CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        totalHeight += (ascent + descent);
    }
    
    leading = kGlobalLineLeading;
    totalHeight += (lineCount * leading);
    
    NSLog(@"totalHeight = %f",totalHeight);
    
    NSLog(@"高度计算完毕");
    return totalHeight;
}

/**
 *  一行一行绘制，未调整行高
 *  对应第三篇博文里的第一个例子
 */
- (void)drawRectWithLineByLine {
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.text];
    [[self class] addGlobalAttributeWithContent:attributed font:self.font];
    
    self.textHeight = [[self class] textHeightWithText:self.text width:self.bounds.size.width font:self.font type:self.drawType];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.textHeight));
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributed);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributed.length), path, NULL);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, self.textHeight); // 此处用计算出来的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
//    CGPathAddRect(path, NULL, CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.textHeight));
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < lineCount; i++) {
        CGPoint point = lineOrigins[i];
        NSLog(@"point.y = %f",point.y);
    }
    NSLog(@"font.ascender = %f,descender = %f,lineHeight = %f,leading = %f",self.font.ascender,self.font.descender,self.font.lineHeight,self.font.leading);
    
    CGFloat frameY = 0;
    for (CFIndex i = 0; i < lineCount; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CGPoint lineOrigin = lineOrigins[i];
        
        
    }
}

+ (void)addGlobalAttributeWithContent:(NSMutableAttributedString *)aContent font:(UIFont *)aFont {
    CGFloat lineLeading = kGlobalLineLeading;
    
    const CFIndex kNumberOfSettings = 2;
    
    CTParagraphStyleSetting lineBreakStyle;
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    lineBreakStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakStyle.valueSize = sizeof(CTLineBreakMode);
    lineBreakStyle.value = &lineBreakMode;
    
    CTParagraphStyleSetting lineSpaceStyle;
    CTParagraphStyleSpecifier spec;
    spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    //    spec = kCTParagraphStyleSpecifierMaximumLineSpacing;
    //    spec = kCTParagraphStyleSpecifierMinimumLineSpacing;
    //    spec = kCTParagraphStyleSpecifierLineSpacing;

    lineSpaceStyle.spec = spec;
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    lineSpaceStyle.value = &lineLeading;
    
    
    CTParagraphStyleSetting lineHeightStyle;
    lineHeightStyle.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    lineHeightStyle.valueSize = sizeof(CGFloat);
    lineHeightStyle.value = &lineLeading;
    
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        lineBreakStyle,
        lineSpaceStyle,
//        lineHeightStyle,
    };
    
    CTParagraphStyleRef theParagraphStyleRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    [aContent addAttribute:NSParagraphStyleAttributeName value:(__bridge id)theParagraphStyleRef range:NSMakeRange(0, aContent.length)];
    
    CFStringRef fontName = (__bridge CFStringRef)aFont.fontName;
    CTFontRef fontRef = CTFontCreateWithName(fontName, aFont.pointSize, NULL);
    
    [aContent addAttribute:NSFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, aContent.length)];
    [aContent addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, aContent.length)];
    CFRelease(theParagraphStyleRef);
    CFRelease(fontRef);
}
@end
