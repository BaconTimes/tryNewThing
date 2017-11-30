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

@property (nonatomic, strong) NSArray <UIViewController *> * vcArrays;

@end

@implementation CircleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    //    [self.view addSubview:_mainScrollView];
    //    _mainScrollView.pagingEnabled = YES;
    //    _mainScrollView.backgroundColor = [UIColor yellowColor];
    
    _normalPostVC = [NormalPostViewController new];
    _perfectPostVC = [PerfectPostViewController new];
    _circleInfoVC = [CircleInfoViewController new];
    
    _vcArrays = @[_normalPostVC, _perfectPostVC, _circleInfoVC];
    NSArray <UIColor *>* cArray = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
    for (NSUInteger i = 0; i < _vcArrays.count; i++) {
        UIViewController * viewController = _vcArrays[i];
        [self addChildViewController:viewController];
        UIView * view = viewController.view;
        view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        view.backgroundColor = cArray[i];
        [self.view addSubview:view];
    }
    //    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.width * vcArrays.count, _mainScrollView.height);
    UISegmentedControl * seg = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3"]];
    [seg addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
}

- (void)segSelected:(UISegmentedControl *)seg {
    NSLog(@"%s %@",__FUNCTION__, @(seg.selectedSegmentIndex));
    [self.view bringSubviewToFront:_vcArrays[seg.selectedSegmentIndex].view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
