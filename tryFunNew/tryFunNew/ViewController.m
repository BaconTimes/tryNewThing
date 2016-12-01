//
//  ViewController.m
//  tryFunNew
//
//  Created by iOSBacon on 2016/11/29.
//  Copyright © 2016年 iOSBacon. All rights reserved.
//

#import "ViewController.h"
#import "TimerShareManager.h"

@interface ViewController ()<TimerShareManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) TimerShareManager * timerShare;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _timerShare = [TimerShareManager sharedInstance];
    _timerShare.currentTimerType = NXTimerTypeEngBind;
    _timerShare.timerDelegate = self;
    if (_timerShare.isExistTimer) {
        _timeLabel.text = [NSString stringWithFormat:@"%@", @(_timerShare.leftCount)];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%@", @(15)];
    }
}

- (IBAction)fireClick:(UIButton *)sender {
    [_timerShare createTimerWithTimerType:NXTimerTypeEngBind totalTime:15 timeInterval:1];
}

- (void)timerWithLeftCount:(NSUInteger)interval {
    [_timeLabel setText:[NSString stringWithFormat:@"%@", @(interval)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
