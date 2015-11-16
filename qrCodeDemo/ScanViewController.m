//
//  ScanViewController.m
//  qrCodeDemo
//
//  Created by vernepung on 15/11/16.
//  Copyright © 2015年 vernepung. All rights reserved.
//
#import "ScanViewController.h"
#import "VPScanQrCodeView.h"
@interface ScanViewController ()
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    CGRect frame = self.view.bounds;
    frame.size.height -= 64.f;
    
    
    VPScanQrCodeView *scanView = [[VPScanQrCodeView alloc]initWithFrame:frame];
    [self.view addSubview:scanView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
