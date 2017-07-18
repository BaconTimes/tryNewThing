//
//  SecondViewController.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/14.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * img = [UIImage imageNamed:@"rainbow.jpg"];
        NSLog(@"%p", img);
    });

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor cyanColor]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)btnClick:(UIButton *)sender {
    ViewController * viewController = [ViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
