//
//  ViewController.m
//  scrollViewSlideAnimation
//
//  Created by 邵朋磊 on 2017/12/7.
//  Copyright © 2017年 spl. All rights reserved.
//

#import "ViewController.h"
#import "SDAutoLayout.h"
#import "ScrollViewSliderAnimation.h"
@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ScrollViewSliderAnimation *scrollView = [[ScrollViewSliderAnimation alloc]initWithFrame:CGRectMake((self.view.width-300)/2, 100, 300,  50)];
    scrollView.dataArray = @[@"200",@"500",@"900",@"1300",@"1600",@"1700",@"1800",@"2000",@"3000",@"3500"];
    [self.view addSubview:scrollView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        scrollView.defultIndex = 1;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
