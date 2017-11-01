//
//  EmojiManager.h
//  VVeboTableViewDemo
//
//  Created by iOSBacon on 2017/7/28.
//  Copyright © 2017年 Johnil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXExpression : NSObject

@property (readonly, nonatomic, copy) NSString *regex; ///<表情匹配的正则字符串
@property (readonly, nonatomic, copy) NSString *plistName; ///<正则表情与图片对应的plist名称
@property (readonly, nonatomic, copy) NSString *bundleName; ///<表情图片所在的bundle名称
@property (nonatomic, assign) CGFloat fontSize; ///<在根据表情生成属性字符串时要用到，即表情图片的大小

+ (instancetype)expressionWithRegex:(NSString*)regex
                          plistName:(NSString*)plistName
                         bundleName:(NSString*)bundleName
                           fontSize:(CGFloat)fontSize;

@end

@interface EmojiManager : NSObject

@property (nonatomic, strong, readonly) NXExpression * defaultExpress;

+ (instancetype)sharedInstance;
+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;
//获取对应的表情attrStr
+ (NSAttributedString*)expressionAttributedStringWithString:(id)string expression:(NXExpression*)expression;
//给一个str数组，返回其对应的表情attrStr数组，顺序一致
+ (NSArray *)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(NXExpression*)expression;
//同上，但是以回调方式返回
+ (void)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(NXExpression*)expression callback:(void(^)(NSArray *result))callback;

@end
