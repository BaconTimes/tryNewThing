//
//  ThirdViewController.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/8/1.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "ThirdViewController.h"
#import "AttributedView.h"
#import "NSString+Additions.h"
#import "UIImage+localImage.h"
#import <YYKit.h>
#import <mach/mach_host.h>
#import "TestRequest.h"

@interface TestCell : UITableViewCell

@property (nonatomic, strong) YYLabel * label;

@end

@implementation TestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width), 0)];
        _label.displaysAsynchronously = YES;
        _label.ignoreCommonProperties = YES;
        _label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSAttributedString * attr = [text attributedSubstringFromRange:range];
            YYTextHighlight * hight =  attr.attributes[YYTextHighlightAttributeName];
            NSLog(@"%@", hight.userInfo);
        };
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end

@interface ThirdViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) NSMutableArray * layouts;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self asycLabel];
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    UIGraphicsBeginImageContext(size); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    
    UIImage *sourceImage = [UIImage imageNamed:@"test.jpg"];
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(long long)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

- (void)asycLabel {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height) - 64) style:UITableViewStylePlain];
    [_tableView registerClass:[TestCell class] forCellReuseIdentifier:@"TestCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _dataSource = [[NSMutableArray alloc] init];
    _layouts = [[NSMutableArray alloc] init];
    
    NSString * bundlePath = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression *netReg = [NSRegularExpression regularExpressionWithPattern:@"(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?))|((https?|ftp|news)://)?([a-z]([a-z0-9\\-]*[\\.。])+([a-z]{2}|aero|arpa|biz|com|coop|edu|gov|info|int|jobs|mil|museum|name|nato|net|org|pro|travel)|(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))(/[a-z0-9_\\-\\.~]+)*(/([a-z0-9_\\-\\.]*)(\\?[a-z0-9+_\\-\\.%=&]*)?)?(#[a-z][a-z0-9_]*)?$" options:NSRegularExpressionCaseInsensitive error:nil];
    for (int i = 0; i < 60; i++) {
        NSString *str = [NSString stringWithFormat:@"%d 永和九年， [委屈]岁在癸丑， [大哭]暮春之初， 会于会稽山阴之兰亭， 💗💛💙🏨🏦🏫修禊事也。[调皮] 群贤毕至，[可怜] 少长咸集。 www.baidu.com此地有崇山峻岭， 茂林修竹， 又有清流激湍， 映带左右， 引以为流觞曲水， 列坐其次。 虽无丝竹管弦之盛，🚖🚌🚋🎊💖💗💛💙🏨🏦🏫😀😖😐😣😡🚖 一觞一咏， 亦足以畅叙幽情。是日也， 天朗气清， 惠风和畅。 仰观宇宙之大， 俯察品类之盛， 所以游目骋怀， 足以极视听之娱， 信可乐也。",i];
        //😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫
        NSMutableAttributedString * muAttr = [[NSMutableAttributedString alloc] initWithString:str];
        NSArray<NSTextCheckingResult *> * results = [reg matchesInString:str options:NSMatchingWithTransparentBounds range:NSMakeRange(0, str.length)];
        for (NSInteger i = results.count - 1; i >= 0; i--) {
            NSTextCheckingResult * result = results[i];
            NSString * resultString = [str substringWithRange:result.range];
            NSString * imgName = dict[resultString];
            if (imgName) {
                NSString * img_path = [bundle pathForResource:imgName ofType:@"png"];
                UIImage * img = [UIImage imageWithContentsOfFile:img_path];
                YYAnimatedImageView * imageView = [[YYAnimatedImageView alloc] initWithImage:img];
                imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
                NSAttributedString * imgAttr = [NSAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFill attachmentSize:CGSizeMake(15, 15) alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
                [muAttr replaceCharactersInRange:result.range withAttributedString:imgAttr];
            }
        }
        str = muAttr.string;
        results = [netReg matchesInString:str options:NSMatchingWithTransparentBounds range:NSMakeRange(0, str.length)];
        for (NSInteger i = results.count - 1; i >= 0; i--) {
            NSTextCheckingResult * result = results[i];
            [muAttr setTextHighlightRange:result.range color:[UIColor redColor] backgroundColor:[UIColor cyanColor] userInfo:@{@1:@1}];
        }

        
        [muAttr setFont:[UIFont systemFontOfSize:15]];
        muAttr.lineBreakMode = NSLineBreakByWordWrapping;
        YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX)];
        container.maximumNumberOfRows = 4;
        YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:muAttr];
        [_dataSource addObject:muAttr];
        [_layouts addObject:layout];
    }
}

- (void)dispatchQueue {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semphore = dispatch_semaphore_create(1);
    NSMutableArray * array = [NSMutableArray new];
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
            [array addObject:@(i)];
            dispatch_semaphore_signal(semphore);
        });
    }
    NSLog(@"%lu", (unsigned long)array.count);
}

- (void)autoreleaseTest {
    @autoreleasepool {
        
        for (NSInteger i = 0; i < 100; i++) {
            TestCell * cell = [TestCell new];
            NSLog(@"cell = %@", cell);
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"TestCell";
    TestCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    YYTextLayout * layout = _layouts[indexPath.row];
    cell.label.size = layout.textBoundingSize;
    cell.label.textLayout = layout;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
