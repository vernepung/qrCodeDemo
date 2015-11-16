//
//  ViewController.m
//  qrCodeDemo
//
//  Created by vernepung on 15/11/16.
//  Copyright © 2015年 vernepung. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"

@interface ViewController ()
{
    NSInteger _count;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_count == 0)
    {
        _count ++;
        ScanViewController *scanVC = [ScanViewController new];
        [self.navigationController pushViewController:scanVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
