//
//  NavgationBarViewController.m
//  对scrollview属性的认知
//
//  Created by Jacky Sun on 16/5/3.
//  Copyright © 2016年 syf. All rights reserved.
//

#import "NavgationBarViewController.h"
#define MaxIconWH  70.0  //用户头像最大的尺寸
#define MinIconWH  30.0  // 用户头像最小的头像
#define MaxIconCenterY  44 // 头像最大的centerY
#define MinIconCenterY 22
#define maxScrollOff 180

@interface NavgationBarViewController ()<UITableViewDelegate>

/**
 *  用户头像
 */
@property (strong, nonatomic) UIImageView * titleIMg;

/**
 *  tableview
 */
@property (weak, nonatomic) IBOutlet UIScrollView * tableVIew;

@end

@implementation NavgationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;// 当我们一个界面有多个tableView之类的,要将它设置为NO,完全由自己手动来布局,就不会错乱了.
   // self.tableVIew.bounces = NO;
    self.tableVIew.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+ 50);
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.titleIMg];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.titleIMg removeFromSuperview];
}


- (UIImageView *)titleIMg{
    if(_titleIMg == nil){
        UIImageView * img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"1.jpg"];
        img.bounds = CGRectMake(0, 0, MaxIconWH, MaxIconWH);
        img.center = CGPointMake(SCREEN_WIDTH*0.5, MaxIconCenterY);
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.borderColor = [UIColor whiteColor].CGColor;
        img.layer.borderWidth = 1.2;
        img.layer.cornerRadius = MaxIconWH/2.0;
        img.layer.masksToBounds = YES;
        _titleIMg = img;
    }
    return _titleIMg;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    // 是scrollview的偏移量
    CGFloat updateY = scrollView.contentOffset.y ;
    NSLog(@"%f",scrollView.contentOffset.y);
    
    
    //  随着scrollview 的滚动， 改变bounds
    CGRect bound = _titleIMg.bounds;
    // 随着滚动缩减的头像的尺寸
    CGFloat reduceW =  updateY  *(MaxIconWH - MinIconWH)/(maxScrollOff - 64);
    reduceW = reduceW < 0 ? 0 : reduceW;
    // 宽度缩小的幅度要和headview偏移的幅度成比例，但是最小的宽度不能小于MinIconWH
    CGFloat yuanw =  MAX(MinIconWH, MaxIconWH - reduceW);
    _titleIMg.layer.cornerRadius = yuanw/2.0;
    bound.size.height = yuanw;
    bound.size.width  = yuanw;
    _titleIMg.bounds = bound;
    
    
    // 改变center  max - min 是滚动 center y值 最大的偏差
    CGPoint center = _titleIMg.center;
    CGFloat yuany =  MAX(MinIconCenterY, MaxIconCenterY - updateY * (MaxIconCenterY - MinIconCenterY)/(maxScrollOff - 64) ) ;
    yuany = yuany > MaxIconCenterY ? MaxIconCenterY : yuany;
    
    center.y = yuany;
    _titleIMg.center = center;
    

    
}


@end
