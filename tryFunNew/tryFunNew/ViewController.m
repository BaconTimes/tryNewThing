//
//  ViewController.m
//  tryFunNew
//
//  Created by iOSBacon on 2016/11/29.
//  Copyright © 2016年 iOSBacon. All rights reserved.
//

#import "ViewController.h"
#import "TimerShareManager.h"
#import "MyBlockUIAlertView.h"
#import "TestModelOne+CoreDataModel.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MyLayout.h>
#import "CTView.h"
#import "AttributedLabel.h"

int (^func()) (int)
{
    return ^(int count){return count + 1;};
}

@interface ViewController ()<TimerShareManagerDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) TimerShareManager * timerShare;

@property (assign, nonatomic) NSUInteger totalTimer;

@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UIView * redView;

@property (nonatomic, strong) UIImageView * imageView;

@property (assign, nonatomic) NSInteger count;

@property (nonatomic, strong) UIButton * btn;

@property (nonatomic, strong) MyLinearLayout * S;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AttributedLabel * attrLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(0, 64, ([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height) - 64)];
    attrLabel.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00];
    [self.view addSubview:attrLabel];
}

- (void)estabBtn {
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btn];
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    [_btn setBackgroundColor:[UIColor cyanColor]];
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:64];
}

- (void)btnClick:(UIButton *)sender {
    _S.myWidth = _S.myWidth + 20;
}

- (void)linear {
    _S = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _S.myTop = 64;
    _S.myWidth = 120;
    _S.subviewSpace = 10;
    
    UIView * A = [UIView new];
    A.myLeft = A.myRight = 5;
    A.myHeight = 40;
    [_S addSubview:A];
    
    UIView * B = [UIView new];
    B.myLeft = 20;
    B.myWidth = B.myHeight = 40;
    [_S addSubview:B];
    
    UIView *C = [UIView new];
    C.myRight = 40;
    C.myWidth = 50;
    C.myHeight = 40;
    [_S addSubview:C];
    
    UIView * D = [UIView new];
    D.myLeft = D.myRight = 10;
    D.myHeight = 40;
    [_S addSubview:D];
    
    [self.view addSubview:_S];
    _S.backgroundColor = [UIColor redColor];
    A.backgroundColor = [UIColor greenColor];
    B.backgroundColor = [UIColor blueColor];
    C.backgroundColor = [UIColor orangeColor];
    D.backgroundColor = [UIColor cyanColor];
}

- (IBAction)jump:(id)sender {
}

- (void)itemLeftClick {
    //要传递的参数一
    NSString *str1 = @"我来自于oc";
    NSString *str = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showAlert('%@');",str1]];
    NSLog(@"JS返回值：%@",str);
    /*
     [[NSBundle mainBundle] URLForResource:DatabaseFileMODEL withExtension:@"momd"]
     */
}

- (void)loadLocalHTML {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"oc_js" ofType:@"html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [_webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    NSLog(@"%@", url.scheme);
    if ([url.scheme isEqualToString:@"firstclick"]) {
        NSArray * paras = [url.query componentsSeparatedByString:@"&"];
        NSMutableDictionary * tmpDict = [NSMutableDictionary new];
        for (NSString * paraStr in paras) {
            NSArray * dicArray = [paraStr componentsSeparatedByString:@"="];
            if (dicArray.count > 1) {
                NSString * decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [tmpDict setObject:decodeValue forKey:dicArray[0]];
            }
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式一" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"tempDic:%@",tmpDict);
    }
    return YES;
}

- (IBAction)fireClick:(UIButton *)sender {
    [_timerShare createTimerWithTimerType:NXTimerTypeEngBind typeKey:@"137" totalTime:_totalTimer timeInterval:1];
}

- (void)timerWithLeftCount:(NSUInteger)interval {
    [_timeLabel setText:[NSString stringWithFormat:@"%@", @(interval)]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animation2WithTouch:touches];
}

- (void)animation1WithTouch:(NSSet<UITouch *> *)touches {
    UITouch * tuch = touches.anyObject;
    CGPoint point = [tuch locationInView:self.view];
    
    [UIView beginAnimations:@"testAnimation" context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(animationDoing)];
    
    [UIView setAnimationDelay:0];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [UIView setAnimationRepeatAutoreverses:YES];
    self.redView.center = point;
    self.redView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.redView.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView commitAnimations];
}

- (void)animation2WithTouch:(NSSet<UITouch *> *)touches {
    //转成动画(flip)
    [UIView beginAnimations:@"imageViewTranslation" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(startAnimation)];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.imageView cache:YES];
    if (++_count % 2 == 0) {
        _imageView.image = [UIImage imageNamed:@"blue.jpg"];
    } else {
        _imageView.image = [UIImage imageNamed:@"rainbow.jpg"];
    }
    [UIView commitAnimations];
}

- (void)startAnimation {
    
}

- (void)stopAnimation {
    
}

- (void)animationDoing {
    NSLog(@"%s",__FUNCTION__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
