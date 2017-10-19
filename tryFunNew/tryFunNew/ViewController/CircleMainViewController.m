//
//  CircleMainViewController.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/10/17.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "CircleMainViewController.h"
#import "PerfectPostViewController.h"
#import "NormalPostViewController.h"
#import "CircleInfoViewController.h"
#import "GlodModel.h"

@interface CircleMainViewController ()

@property (nonatomic, strong) UIScrollView * mainScrollView;

@property (nonatomic, strong) NormalPostViewController * normalPostVC;

@property (nonatomic, strong) PerfectPostViewController * perfectPostVC;

@property (nonatomic, strong) CircleInfoViewController * circleInfoVC;

@end

@implementation CircleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.backgroundColor = [UIColor yellowColor];
    
    _normalPostVC = [NormalPostViewController new];
    _perfectPostVC = [PerfectPostViewController new];
    _circleInfoVC = [CircleInfoViewController new];
    
    NSArray <UIViewController *> * vcArrays = @[_normalPostVC, _perfectPostVC, _circleInfoVC];
    NSArray <UIColor *>* cArray = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
    for (NSUInteger i = 0; i < vcArrays.count; i++) {
        UIViewController * viewController = vcArrays[i];
        [self addChildViewController:viewController];
        UIView * view = viewController.view;
        view.frame = CGRectMake(_mainScrollView.width * i, 0, _mainScrollView.width, _mainScrollView.height);
        view.backgroundColor = cArray[i];
        [_mainScrollView addSubview:view];
    }
    
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.width * vcArrays.count, _mainScrollView.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
