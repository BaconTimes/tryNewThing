//
//  SecondViewController.m
//  tryFunNew
//
//  Created by iOSBacon on 2017/7/14.
//  Copyright © 2017年 iOSBacon. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "ThirdViewController.h"
#import "GlodModel.h"
#import "GoldDataCenter.h"
#import "CircleMainViewController.h"

dispatch_time_t getDispatchTimeByDate(NSDate * date)
{
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
}

@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * mainTableView;

@property (nonatomic, strong) NSMutableArray<GlodModel *> * dataSource;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:_mainTableView];
    [self refreshData];
}

- (void)createData {
    _dataSource = [NSMutableArray new];
    NSMutableArray * muArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        GlodModel * gModel = [[GlodModel alloc] init];
        gModel.targetId = [NSString stringWithFormat:@"41234%@", @(i)];
        gModel.name = [NSString stringWithFormat:@"name%@", @(i)];
        gModel.height = 170 + i;
        gModel.width = 1700 + i;
        gModel.weight = 65 + i;
        [_dataSource addObject:gModel];
        [GoldDataCenter insertGold:gModel];
        [muArray addObject:[gModel modelToJSONString]];
    }
    
}

- (IBAction)rightAction:(UIBarButtonItem *)sender {
    NSUInteger baseNum = 15;
    for (NSInteger i = 0; i < 5000; i++, baseNum++) {
        GlodModel * gModel = [[GlodModel alloc] init];
        gModel.targetId = [NSString stringWithFormat:@"41234%@", @(baseNum)];
        gModel.name = [NSString stringWithFormat:@"name%@", @(baseNum)];
        gModel.height = 170 + i;
        gModel.width = 1700 + i;
        gModel.weight = 65 + i;
        [GoldDataCenter insertGold:gModel];
    }
}

- (IBAction)addAction:(UIBarButtonItem *)sender {
    for (NSInteger i = 0; i < 5000; i++) {
        GlodModel * gModel = [[GlodModel alloc] init];
        gModel.targetId = [NSString stringWithFormat:@"41234%@", @(i)];
        gModel.name = [NSString stringWithFormat:@"name%@", @(i)];
        gModel.height = 170 + i;
        gModel.width = 1700 + i;
        gModel.weight = 65 + i;
        [_dataSource addObject:gModel];
    }
    [self refreshData];
}
- (IBAction)trashAction:(id)sender {
    NSUInteger i = 5;
    do {
        [_dataSource removeObjectAtIndex:0];
    } while (i--);
    [self refreshData];
}

- (void)refreshData {
    [_mainTableView reloadData];
    self.title = [NSString stringWithFormat:@"%@", @(_dataSource.count)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self.navigationController pushViewController:[CircleMainViewController new] animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row].name;
    return cell;
}

- (void)testBasicBtn {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor cyanColor]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UIButton * tableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableBtn setTitle:@"tableBtn" forState:UIControlStateNormal];
    [tableBtn setBackgroundColor:[UIColor cyanColor]];
    [tableBtn addTarget:self action:@selector(tableBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tableBtn];
    
    [tableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(btn.mas_bottom).offset(10);
        make.centerX.equalTo(btn);
    }];
}

- (void)imageOrientationTest {
    UIImage * image = [UIImage imageNamed:@"about"];
    UIImage * tmpImgLeft = [self image:image rotation:UIImageOrientationLeft];
    UIImage * tmpImgRight = [self image:image rotation:UIImageOrientationRight];
    UIImage * tmpImgDown = [self image:image rotation:UIImageOrientationDown];
    UIImage * tmpImgUp = [self image:image rotation:UIImageOrientationUp];
    [self writeImage:tmpImgLeft imageName:@"tmpImgLeft"];
    [self writeImage:tmpImgRight imageName:@"tmpImgRight"];
    [self writeImage:tmpImgDown imageName:@"tmpImgDown"];
    [self writeImage:tmpImgUp imageName:@"tmpImgUp"];
}

- (void)writeImage:(UIImage*)image imageName:(NSString *)imageName {
    NSData * data = UIImagePNGRepresentation(image);
    NSString * suffixe = @"png";
    if (data == nil) {
        suffixe = @"jpeg";
        data = UIImageJPEGRepresentation(image, 1);
    }
    NSString * filePath = [NSString stringWithFormat:@"/Users/iosbacon/Desktop/%@.%@", imageName, suffixe];
    NSLog(@"filePath = %@", filePath);
    [data writeToFile:filePath atomically:YES];
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

- (void)tableBtnClick:(UIButton *)sender {
    [self.navigationController pushViewController:[ThirdViewController new] animated:YES];
}

- (void)btnClick:(UIButton *)sender {
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:@"http://0.0.0.0:5000/todo/api/v1.0/tasks"];
//    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLSessionTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data string = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (error) {
            NSLog(@"error = %@", error.description);
        }
    }];
    [task resume];
//    ViewController * viewController = [ViewController new];
//    [self.navigationController pushViewController:viewController animated:YES];
}
@end
