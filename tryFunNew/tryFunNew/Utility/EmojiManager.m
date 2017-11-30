//
//  EmojiManager.m
//  VVeboTableViewDemo
//
//  Created by iOSBacon on 2017/7/28.
//  Copyright © 2017年 Johnil. All rights reserved.
//

#import "EmojiManager.h"

#define REGULAREXPRESSION_OPTION(regularExpression,regex,option) \
\
static NSRegularExpression * k##regularExpression() { \
static NSRegularExpression *_##regularExpression = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_##regularExpression = [[NSRegularExpression alloc] initWithPattern:(regex) options:(option) error:nil];\
});\
\
return _##regularExpression;\
}\

#define REGULAREXPRESSION(regularExpression,regex) REGULAREXPRESSION_OPTION(regularExpression,regex,NSRegularExpressionCaseInsensitive)


REGULAREXPRESSION(URLRegularExpression,@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,6})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,6})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)")
REGULAREXPRESSION(PhoneNumerRegularExpression, @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[3578]+\\d{9}|[+]861+[3578]+\\d{9}|861+[3578]+\\d{9}|1+[3578]+\\d{1}-\\d{4}-\\d{4}|\\d{8}|\\d{7}|400-\\d{3}-\\d{4}|400-\\d{4}-\\d{3}")


#define EMOJIBUNDLENAME @"emotion.bundle"
#define EMOJIPLISTNAME @"emoji.plist"
#define EMOJIFONTSIZE (16.0f)
#define EMOJIREG @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"

static EmojiManager * _manager;

@interface NXExpression()

@property (nonatomic, copy) NSString *regex;
@property (nonatomic, copy) NSString *plistName;
@property (nonatomic, copy) NSString *bundleName;

@property (nonatomic, strong) NSRegularExpression *expressionRegularExpression;
@property (nonatomic, strong) NSDictionary *expressionMap;

- (BOOL)isValid;

@end

@interface EmojiManager()
@property (nonatomic, strong) NSMutableDictionary *expressionMapRecords;
@property (nonatomic, strong) NSMutableDictionary *expressionRegularExpressionRecords;
@property (nonatomic, strong) NXExpression * defaultExpress;
@end

@implementation EmojiManager

+ (instancetype)sharedInstance {
    static EmojiManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc]init];
    });
    return _sharedInstance;
}

- (NXExpression *)defaultExpress {
    if (_defaultExpress == nil) {
        _defaultExpress = [NXExpression expressionWithRegex:EMOJIREG plistName:EMOJIPLISTNAME bundleName:EMOJIBUNDLENAME fontSize:EMOJIFONTSIZE];
    }
    return _defaultExpress;
}

#pragma mark - getter
- (NSMutableDictionary *)expressionMapRecords
{
    if (!_expressionMapRecords) {
        _expressionMapRecords = [NSMutableDictionary new];
    }
    return _expressionMapRecords;
}

- (NSMutableDictionary *)expressionRegularExpressionRecords
{
    if (!_expressionRegularExpressionRecords) {
        _expressionRegularExpressionRecords = [NSMutableDictionary new];
    }
    return _expressionRegularExpressionRecords;
}

#pragma mark - common
- (NSDictionary*)expressionMapWithPlistName:(NSString*)plistName
{
    NSAssert(plistName&&plistName.length>0, @"expressionMapWithRegex:参数不得为空");
    
    if (self.expressionMapRecords[plistName]) {
        return self.expressionMapRecords[plistName];
    }
    
    NSString *plistPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSAssert(dict,@"表情字典%@找不到,请注意大小写",plistName);
    self.expressionMapRecords[plistName] = dict;
    
    return self.expressionMapRecords[plistName];
}

- (NSRegularExpression*)expressionRegularExpressionWithRegex:(NSString*)regex
{
    NSAssert(regex&&regex.length>0, @"expressionRegularExpressionWithRegex:参数不得为空");
    
    if (self.expressionRegularExpressionRecords[regex]) {
        return self.expressionRegularExpressionRecords[regex];
    }
    
    NSRegularExpression *re = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSAssert(re,@"正则%@有误",regex);
    self.expressionRegularExpressionRecords[regex] = re;
    
    return self.expressionRegularExpressionRecords[regex];
}

//多线程转表情attrStr
+ (NSArray *)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(NXExpression*)expression
{
    if (expression == nil) expression = [EmojiManager sharedInstance].defaultExpress;
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:strings.count];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (id str in strings) {
        dispatch_group_async(group, queue, ^{
            NSAttributedString *result = [EmojiManager expressionAttributedStringWithString:str expression:expression];
            @synchronized(results){
                results[str] = result;
            }
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    //重新排列
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:results.count];
    for (id str in strings) {
        [resultArr addObject:results[str]];
    }
    
    return resultArr;
}

+ (void)expressionAttributedStringsWithStrings:(NSArray*)strings expression:(NXExpression*)expression callback:(void(^)(NSArray *result))callback
{
    if (expression == nil) expression = [EmojiManager sharedInstance].defaultExpress;
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:strings.count];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (id str in strings) {
        dispatch_group_async(group, queue, ^{
            NSAttributedString *result = [self expressionAttributedStringWithString:str expression:expression];
            
            @synchronized(results){
                results[str] = result;
            }
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        //重新排列
        NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:results.count];
        for (id str in strings) {
            [resultArr addObject:results[str]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(resultArr);
            }
        });
    });
}

+ (NSAttributedString*)expressionAttributedStringWithString:(id)string expression:(NXExpression*)expression {
    if (expression == nil) expression = [EmojiManager sharedInstance].defaultExpress;
    NSAssert(expression&&[expression isValid], @"expression invalid");
    NSAssert([string isKindOfClass:[NSString class]]||[string isKindOfClass:[NSAttributedString class]], @"string非字符串. %@",string);
    
    NSAttributedString *attributedString = nil;
    if ([string isKindOfClass:[NSString class]]) {
        attributedString = [[NSAttributedString alloc]initWithString:string];
    }else{
        attributedString = string;
    }
    
    if (attributedString.length<=0) {
        return attributedString;
    }
    
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    //处理表情
    NSArray *results = [expression.expressionRegularExpression matchesInString:attributedString.string
                                                                       options:NSMatchingWithTransparentBounds
                                                                         range:NSMakeRange(0, [attributedString length])];
    //遍历表情，然后找到对应图像名称，并且处理
    NSUInteger location = 0;
    for (NSTextCheckingResult *result in results) {
        NSRange range = result.range;
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:NSMakeRange(location, range.location - location)];
        //先把非表情的部分加上去
        [resultAttributedString appendAttributedString:subAttrStr];
        
        //下次循环从表情的下一个位置开始
        location = NSMaxRange(range);
        
        NSAttributedString *expressionAttrStr = [attributedString attributedSubstringFromRange:range];
        NSString *imageName = expression.expressionMap[expressionAttrStr.string];
        if (imageName.length>0) {
            //加个表情到结果中
            UIImage *image = nil;
            if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
                NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:expression.bundleName withExtension:nil]];
                image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
            }else{
                NSString *imagePath = [expression.bundleName stringByAppendingPathComponent:imageName];
                image = [UIImage imageNamed:imagePath];
            }
            NSAttributedString * imgAttr = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:expression.fontSize];
            [resultAttributedString appendAttributedString:imgAttr];
        }else{
            //找不到对应图像名称就直接加上去
            [resultAttributedString appendAttributedString:expressionAttrStr];
        }
    }
    
    if (location < [attributedString length]) {
        //到这说明最后面还有非表情字符串
        NSRange range = NSMakeRange(location, [attributedString length] - location);
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:range];
        [resultAttributedString appendAttributedString:subAttrStr];
    }
    
    return resultAttributedString;
}

+ (NSMutableAttributedString *)detectLink:(id)string color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor {
    if (string == nil) return nil;
    NSMutableAttributedString * muAttr = [[NSMutableAttributedString alloc] init];
    if ([string isKindOfClass:[NSString class]])
        [muAttr appendString:(NSString *)string];
    else if ([string isKindOfClass:[NSAttributedString class]])
        [muAttr appendAttributedString:(NSAttributedString *)string];
    NSString *totalString = muAttr.string;
    NSArray<NSTextCheckingResult *> * urlResults = [kURLRegularExpression() matchesInString:totalString options:NSMatchingWithTransparentBounds range:NSMakeRange(0,totalString.length)];
    NSMutableArray <NSValue *> * rangeArray = [NSMutableArray arrayWithCapacity:urlResults.count];
    for (NSTextCheckingResult * result in urlResults) {
        [rangeArray addObject:[NSValue valueWithRange:result.range]];
        [muAttr setTextHighlightRange:result.range color:color backgroundColor:backgroundColor userInfo:nil];
    }
    NSArray<NSTextCheckingResult *> * phoneResults = [kPhoneNumerRegularExpression() matchesInString:totalString options:NSMatchingWithTransparentBounds range:NSMakeRange(0,totalString.length)];
    for (NSTextCheckingResult * result in phoneResults) {
        BOOL isIntersected = NO;
        for (NSValue * rangeValue in rangeArray) {
            NSRange linkRange = [rangeValue rangeValue];
            if (NSMaxRange(NSIntersectionRange(linkRange, result.range))>0) {
                isIntersected = YES;
                break;
            }
        }
        if (isIntersected) {
            continue;
        } else {
            [muAttr setTextHighlightRange:result.range color:color backgroundColor:backgroundColor userInfo:nil];
        }
    }
    return muAttr;
}

@end

@implementation NXExpression

- (BOOL)isValid
{
    return self.expressionRegularExpression&&self.expressionMap&&self.bundleName.length>0;
}

+ (instancetype)expressionWithRegex:(NSString*)regex plistName:(NSString*)plistName bundleName:(NSString*)bundleName fontSize:(CGFloat)fontSize
{
    NXExpression *expression = [NXExpression new];
    expression.regex = regex;
    expression.plistName = plistName;
    expression.bundleName = bundleName;
    expression.fontSize = fontSize;
    NSAssert([expression isValid], @"此expression无效，请检查参数");
    return expression;
}

#pragma mark - setter
- (void)setRegex:(NSString *)regex
{
    NSAssert(regex.length>0, @"regex length must >0");
    _regex = [regex copy];
    
    self.expressionRegularExpression = [[EmojiManager sharedInstance] expressionRegularExpressionWithRegex:regex];
}

- (void)setPlistName:(NSString *)plistName
{
    NSAssert(plistName.length>0, @"plistName's length must >0");
    
    _plistName = [plistName copy];
    
    if (![[_plistName lowercaseString] hasSuffix:@".plist"]) {
        _plistName = [_plistName stringByAppendingString:@".plist"];
    }
    
    self.expressionMap = [[EmojiManager sharedInstance]expressionMapWithPlistName:_plistName];
}

- (void)setBundleName:(NSString *)bundleName
{
    _bundleName = [bundleName copy];
    
    if (![[_bundleName lowercaseString] hasSuffix:@".bundle"]) {
        _bundleName = [_bundleName stringByAppendingString:@".bundle"];
    }
}

@end
