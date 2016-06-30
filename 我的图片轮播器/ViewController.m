//
//  ViewController.m
//  我的图片轮播器
//
//  Created by 唐姚 on 16/4/18.
//  Copyright © 2016年 唐姚. All rights reserved.
//

#import "ViewController.h"
#import "KVImageCyclePlayer.h"
#import "UIView+Extension.h"

@interface ViewController ()
@property (nonatomic,weak) KVImageCyclePlayer * cycleImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载图片名
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        NSString * name = [NSString stringWithFormat:@"car%d", i];
        [array addObject:name];
    }
    
    // 实例化图片轮播器
    KVImageCyclePlayer * cycleImageView = [[KVImageCyclePlayer alloc] initWithImageNames:array];
    cycleImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [cycleImageView addTarget:self action:@selector(segmentDidChange:)];
    [self.view addSubview:cycleImageView];
    self.cycleImageView = cycleImageView;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 100)];
    
    label.x = 0;
    label.y = 100;
    label.width = self.view.width;
    label.height = 100;
    
    label.text = @"我的图片轮播器";
    label.font = [UIFont systemFontOfSize:20];
    label.font = [UIFont fontWithName:@"KaiTi" size:40];
    label.backgroundColor = [UIColor grayColor];
//    label.hidden = NO;
    [self.view addSubview:label];
}

#pragma mark - 响应方法
- (void) segmentDidChange:(KVImageCyclePlayer *)cycleImageView
{
    NSLog(@"%ld", cycleImageView.currentShowPage);
}


@end
