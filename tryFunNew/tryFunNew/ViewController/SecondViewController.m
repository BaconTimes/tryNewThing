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
#import "TouchView.h"
#import "MRCTest.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>
static NSString * evaluateJsH5Content = @"document.documentElement.innerHTML";

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

@interface SecondViewController ()<
UITableViewDelegate,
UITableViewDataSource,
NSFetchedResultsControllerDelegate,
WKNavigationDelegate,
AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UITableView * mainTableView;

@property (nonatomic, strong) NSMutableArray<GlodModel *> * dataSource;

@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIWebView * web;

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

@end

@implementation SecondViewController {
    NSInteger total;
    HTTPServer * httpServer;
    GlodModel * _gModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = CGRectMake(50, 50, 50, 50);
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.backgroundColor = [UIColor redColor].CGColor;
    self.previewLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
//    [self.session stopRunning];
}

-(void)viewWillLayoutSubviews {
    _web.frame = self.view.bounds;
}

- (void)testBlockCopy {
    _gModel = [GlodModel new];
    _gModel.height = 2;
    _gModel.name = @"hehe";
    NSLog(@"main _gModel.address%p", _gModel);
    void(^testblk)()= ^{
        NSLog(@"blk _gModel.address%p", _gModel);
    };
    testblk();
    NSLog(@"_gModel.height = %@", @(_gModel.height));
}

- (void)netWorkFileUpload {
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    NSString * webPath = [[NSBundle mainBundle] resourcePath];
    [httpServer setDocumentRoot:webPath];
    [httpServer setPort:12345];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    NSError * err; //  442  curl -H "Content-type: application/json" -X POST http://10.100.23.49:5000/todo/api/v1.0/tasks -d '{"message":"Hello Data"}'

    if ([httpServer start:&err]) {
        NSLog(@"port %hu", [httpServer listeningPort]);
    }else {
        NSLog(@"err is %@", err);
    }
}

- (void)test1 {
    [self fetchedResultsController];
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
    for (NSInteger i = 0; i < 5; i++) {
        GlodModel * gModel = [[GlodModel alloc] init];
        gModel.targetId = [NSString stringWithFormat:@"41234%@", @(i)];
        gModel.name = [NSString stringWithFormat:@"name%@", @(i)];
        gModel.height = 170 + i;
        gModel.width = 1700 + i;
        gModel.weight = 65 + i;
        [_dataSource addObject:gModel];
    }
}

- (NSFetchedResultsController * )fetchedResultsController {
    if(_fetchedResultsController != nil) return _fetchedResultsController;
    NSFetchRequest * fetchRequest = [Gold fetchRequest];
    NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor * secDesc = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    
    fetchRequest.sortDescriptors = @[sortDesc,  secDesc];
//    [NSFetchedResultsController deleteCacheWithName:nil];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError * error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _fetchedResultsController;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = _fetchedResultsController.sections.count;
    NSLog(@"numberOfSectionsInTableView = %@", @(count));
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = _fetchedResultsController.sections[section].numberOfObjects;
    NSLog(@"numberOfRowsInSection = %@", @(count));
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[NSClassFromString(@"CircleMainViewController") new] animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    Gold * gold = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString * text = gold.name;
    cell.textLabel.text = text;
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_mainTableView reloadData];
    NSLog(@"%s",__FUNCTION__);
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"%s",__FUNCTION__);
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"%s",__FUNCTION__);
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"%s",__FUNCTION__);
}

-(NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    NSLog(@"%s",__FUNCTION__);
    return sectionName;
}


- (IBAction)rightAction:(UIBarButtonItem *)sender {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"bundle"];
    NSBundle * bundle = [NSBundle bundleWithPath:path];
    NSLog(@"bundle.load = %@",[bundle load]?@"YES":@"NO");
    NSLog(@"bundle.load = %@",bundle.isLoaded?@"YES":@"NO");
    NSUInteger baseNum = 15;
    for (NSInteger i = 0; i < 200; i++, baseNum++) {
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
    for (NSInteger i = 0; i < 1; i++) {
        GlodModel * gModel = [[GlodModel alloc] init];
        gModel.targetId = [NSString stringWithFormat:@"41132234%@", @(i)];
        gModel.name = [NSString stringWithFormat:@"name1231%@", @(i)];
        gModel.height = 170 + i;
        gModel.width = 1700 + i;
        gModel.weight = 65 + i;
        [GoldDataCenter insertGold:gModel];
    }
}

- (IBAction)trashAction:(id)sender {
    NSLog(@"%@", @([Gold MR_countOfEntities]));
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray * goldArray = [Gold MR_findAllInContext:localContext];
        for (Gold * gold in goldArray) {
            [gold MR_deleteEntity];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        NSLog(@"delete complete");
    }];
}

- (void)refreshData {
    [_mainTableView reloadData];
    self.title = [NSString stringWithFormat:@"%@", @(_fetchedResultsController.sections[0].numberOfObjects)];
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
}


- (void)abstractCount:(NSInteger)count fromList:(NSArray *)list {
    NSMutableArray * path = [NSMutableArray new];
    NSMutableArray * left = [NSMutableArray arrayWithArray:list];
    NSMutableArray * result = [NSMutableArray new];
    [self abstractLevel:count path:path left:left result:result];
}

- (void)abstractLevel:(NSInteger)level path:(NSMutableArray *)path left:(NSMutableArray *)left result:(NSMutableArray *)result;
{
    if (level == 1) {
        for (id object in left) {
            NSMutableArray * muArr = [NSMutableArray arrayWithArray:path];
            [muArr addObject:object];
            [result addObject:muArr];
        }
    } else {
        for (NSInteger i = 0; i < left.count; i++) {
            id object = left[i];
            NSMutableArray * tmpPath = [NSMutableArray arrayWithArray:path];
            [tmpPath addObject:object];
            NSMutableArray * tmpLeft = [NSMutableArray arrayWithArray:[left subarrayWithRange:NSMakeRange(i + 1, left.count - i - 1)]];
            [self abstractLevel:level - 1 path:tmpPath left:tmpLeft result:result];
        }
    }
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

@end
