//
//  ViewController.m
//  对scrollview属性的认知
//
//  Created by Jacky Sun on 16/5/3.
//  Copyright © 2016年 syf. All rights reserved.
//
#define HeadHeight 278 // headView的高度
#define MaxIconWH  100.0  //用户头像最大的尺寸
#define MinIconWH  30.0  // 用户头像最小的头像
#define MaxIconCenterY 120 // 头像最大的centerY
#define MinIconCenterY 42
#define HeadContentOffset @"contentOffset"

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *backScroll;
/**
 *  表头的view
 */
@property (strong, nonatomic) UIView * headView;
/**
 *  代替navigationbar 的自定义view
 */
@property (weak, nonatomic) IBOutlet UIView *navbarView;

/**
 *  用户头像
 */
@property (strong, nonatomic) UIImageView * titleIMg;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScrollViewHeadView];
    [self.backScroll addSubview:self.headView];
    [self.navbarView addSubview:self.titleIMg];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


/**
 *  初始化headview
 */
- (void)setUpScrollViewHeadView{
    
    self.backScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 2);
    self.backScroll.contentInset = UIEdgeInsetsMake(HeadHeight, 0, 0, 0);
    // KVO
    [self.backScroll addObserver:self forKeyPath:HeadContentOffset  options:NSKeyValueObservingOptionNew context:nil];
    [self.backScroll setContentOffset: CGPointMake(0, -HeadHeight) animated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if(![keyPath isEqualToString:HeadContentOffset])
        return;
    [self scrollViewDidScroll:self.backScroll];
}


- (UIView *)headView{
    if(_headView == nil){
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, -HeadHeight, SCREEN_WIDTH, HeadHeight)];
        _headView.backgroundColor = DRHColor(233, 73, 71);
    }
    return _headView;
}


- (UIImageView *)titleIMg{
    if(_titleIMg == nil){
        UIImageView * img = [[UIImageView alloc] init];
        img.center = CGPointMake(SCREEN_WIDTH/2.0, MaxIconCenterY);
        img.bounds = CGRectMake(0, 0, MaxIconWH ,MaxIconWH );
        img.image = [UIImage imageNamed:@"1.jpg"];
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
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < -HeadHeight) {
        CGRect currentFrame = self.headView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = -1*offsetY;
        self.headView.frame = currentFrame;
    }
    
    // 是scrollview的偏移量
    CGFloat updateY = scrollView.contentOffset.y + HeadHeight;

    
    //  随着scrollview 的滚动， 改变bounds
      CGRect bound = _titleIMg.bounds;
    // 随着滚动缩减的头像的尺寸
     CGFloat reduceW = updateY  *(MaxIconWH - MinIconWH)/(HeadHeight - 64);
    // 宽度缩小的幅度要和headview偏移的幅度成比例，但是最小的宽度不能小于MinIconWH
     CGFloat yuanw =  MAX(MinIconWH, MaxIconWH - reduceW);
    
    NSLog(@"-----%f+++++++%f",reduceW,yuanw);
    
    
    _titleIMg.layer.cornerRadius = yuanw/2.0;
    bound.size.height = yuanw;
    bound.size.width  = yuanw;
    _titleIMg.bounds = bound;

    
    // 改变center  max - min 是滚动 center y值 最大的偏差
    CGPoint center = _titleIMg.center;
    CGFloat yuany =  MAX(MinIconCenterY, MaxIconCenterY - updateY * (MaxIconCenterY - MinIconCenterY)/(HeadHeight - 64) ) ;
    
    center.y = yuany;
    _titleIMg.center = center;

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
