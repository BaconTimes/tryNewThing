//
//  Core1ImageView.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/21.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "Core1ImageView.h"
#import <CoreText/CoreText.h>

@implementation Core1ImageView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1.获取上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // [a, b, c,d, tx,ty]
    NSLog(@"转换前的坐标: %@", NSStringFromCGAffineTransform(CGContextGetCTM(contextRef)));
    
    // 2.转换坐标系，CoreText的原点在左下角，UIKit原点在在左上角
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    
    // 这两种转换坐标的方式效果一样
    /*
     2.1
     CGContextTranslateCTM(contextRef, 0, self.bounds.size.height);
     CGContextScaleCTM(contextRef, 1, -1);
     */
    
    // 2.2
    CGContextConcatCTM(contextRef, CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height));
    
    NSLog(@"转换后的坐标: %@", NSStringFromCGAffineTransform(CGContextGetCTM(contextRef)));
    
    // 3.穿件绘制区域，可以对path进行个性化裁剪以改变显示区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
//    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    // 4.创建需要绘制的文字
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:@"某天，我在玩伴的家中玩耍，母亲当时说回家做点槐花糕，过会儿来接我，刚开始我跟伙伴一起在玩小木偶，过了一会儿，忘记是谁提出的好点子，我们就偷偷溜去田地里挖野菜，跑到场地，开挖，当时并不认识挖的什么菜，现在想想也许是苦菜、荠菜等等，小孩子嘛，纯属玩，并不是所谓的劳动，没有疲倦反倒“乐”乎所以，于是我们忘记了时间去了哪。中午，田野里劳作的人都回家吃饭了，一望无际的田地里只留下我跟小伙伴在专心的‘劳作’。突然，渐渐传来的一声声熟悉的喊叫打破了我们的专注，多年后，我依旧清晰的记得那个憔悴的背影……她越走越近，没错，就是我那大嗓门，如河东狮吼般的母亲，不记得当时她是哪副模样，惶恐？责备？宠爱？随后意料中的一批痛训，握着显得更为稚嫩的一双小手回到了家……那是我从母亲眼中第一次看见泪花，年幼的我吓哭了。回家后，她急忙拿出刚做好的槐花糕，不记得当时吃了几个，只记得好多，好香"];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, attributed.length)];
    
    [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, 10)];
    [attributed addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 2)];
    
    // 设置行距等样式
    CGFloat lineSpace = 20; //行距一般取决于
    CGFloat lineSpaceMax = 20;
    CGFloat lineSpaceMin = 2;
    const CFIndex kNumberOfSettings = 3;
    
    //结构体数组
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &lineSpaceMax},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpaceMin}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    [attributed addAttribute:NSParagraphStyleAttributeName value:(__bridge id)theParagraphRef range:NSMakeRange(0, attributed.length)];
    CFRelease(theParagraphRef);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributed);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributed.length), path, NULL);
    CTFrameDraw(ctFrame, contextRef);
    
    // 7.内存管理，ARC不能管理CF开头的对象，需要我们自己手动释放内存
    CFRelease(path);
    CFRelease(framesetter);
    CFRelease(ctFrame);
}

@end
