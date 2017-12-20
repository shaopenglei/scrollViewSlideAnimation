//
//  ScrollViewSliderAnimation.m
//  scrollViewSlideAnimation
//
//  Created by 邵朋磊 on 2017/12/7.
//  Copyright © 2017年 spl. All rights reserved.
//

#import "ScrollViewSliderAnimation.h"
#import "SDAutoLayout.h"
#define sliderLabelX 5
#define sliderLabelHeight 50
#define ReduceTheRatio  0.7
#define sliderLabelMaxX(label) (label.frame.origin.x + label.frame.size.width)
/**是否3.5寸屏*/
#define is3_5Inch             ([UIScreen mainScreen].bounds.size.height == 480.0)

/**是否4寸屏 */
#define is4Inch             ([UIScreen mainScreen].bounds.size.height == 568.0)

/**是否4.7寸屏**/
//宽375
#define is4_7Inch             ([UIScreen mainScreen].bounds.size.height == 667.0)
#define FONTSIZE ((is3_5Inch||is4Inch)?0.8:is4_7Inch?1.0:1.1)
#define FONT(FONTNAME,F) [[UIDevice currentDevice].systemVersion doubleValue]<9.0?[UIFont systemFontOfSize:F*FONTSIZE]:[UIFont fontWithName:FONTNAME size:F*FONTSIZE]
@interface ScrollViewSliderAnimation ()<UIScrollViewDelegate>

@end

@implementation ScrollViewSliderAnimation
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.SliderLabelWidth = 85;
        self.clipsToBounds = YES;
        [self BuildScrollView];
    }
    return self;
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self buildScrollViewData];
}
- (void)buildScrollViewData{
    [[self.scrollview subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.sliderLabelArray removeAllObjects];
    for (int i=0; i<self.dataArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.SliderLabelWidth-sliderLabelX*2)*i-sliderLabelX, 10, self.SliderLabelWidth, sliderLabelHeight-20)];
        label.backgroundColor = [UIColor clearColor];
        if (i==0) {
            label.textColor = [self getColor:@"EC630F" andAlpha:1];
            label.font = FONT(@"PingFangSC-Medium", 35);
        }else{
            label.font = FONT(@"PingFangSC-Regular", 35);
            label.textColor = [self getColor:@"CDCDCD" andAlpha:1];
        }
        label.text = [NSString stringWithFormat:@"%@",self.dataArray[i]];
        label.textAlignment = NSTextAlignmentCenter;
        if (i!=0) label.transform = CGAffineTransformMakeScale(ReduceTheRatio, ReduceTheRatio);
        [self.sliderLabelArray addObject:label];
        [self.scrollview addSubview:label];
    }
    self.scrollview.contentSize = CGSizeMake((self.SliderLabelWidth-sliderLabelX*2)*self.dataArray.count, sliderLabelHeight);
}
- (void)BuildScrollView{
    self.scrollview = [[UIScrollView alloc]init];
    self.scrollview.backgroundColor = [UIColor clearColor];
    self.scrollview.bounces = NO;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.clipsToBounds = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
    [self addSubview:self.scrollview];
    self.scrollview.sd_layout.topSpaceToView(self, 0)
    .centerXEqualToView(self)
    .heightIs(self.height)
    .widthIs(self.SliderLabelWidth-sliderLabelX*2);
    
    UIColor *colorOne = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:0.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,  nil];
    
    UIView *leftView = [[UIView alloc]init];
    [self addSubview:leftView];
    leftView.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .widthIs(32);
    CAGradientLayer *leftHeaderLayer = [CAGradientLayer layer];
    leftHeaderLayer.colors = colors;
    leftHeaderLayer.startPoint = CGPointMake(0, 0);
    leftHeaderLayer.endPoint = CGPointMake(1, 0);
    leftHeaderLayer.frame = CGRectMake(0, 0, 32, self.height);
    [leftView.layer insertSublayer:leftHeaderLayer above:0];
    
    UIView *rightView = [[UIView alloc]init];
    [self addSubview:rightView];
    rightView.sd_layout.topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .widthIs(32);
    CAGradientLayer *rightHeaderLayer = [CAGradientLayer layer];
    rightHeaderLayer.colors = colors;
    rightHeaderLayer.startPoint = CGPointMake(1, 0);
    rightHeaderLayer.endPoint = CGPointMake(0, 0);
    rightHeaderLayer.frame = CGRectMake(0, 0, 32, self.height);
    [rightView.layer insertSublayer:rightHeaderLayer above:0];
}
#pragma mark -- 这个方法可以在scrollView外滑动View
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]){
        for (UIView *subview in _scrollview.subviews){
            CGPoint offset = CGPointMake(point.x - _scrollview.frame.origin.x + _scrollview.contentOffset.x - subview.frame.origin.x, point.y - _scrollview.frame.origin.y + _scrollview.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event])){
                return view;
            }
        }
        return _scrollview;
    }
    return view;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    int index= contentOffsetX / scrollView.width;
    float centerX = contentOffsetX + scrollView.width/2;
    for (int i=0; i<self.sliderLabelArray.count; i++) {
        UILabel *label = self.sliderLabelArray[i];
        label.font = FONT(@"PingFangSC-Regular", 35);
        label.textColor = [self getColor:@"CDCDCD" andAlpha:1];
        if (i<=index) {
            float distance = centerX-label.centerX;
            float multiple = distance/scrollView.width;
            float scale = MIN(MAX(1-multiple, ReduceTheRatio), 1);
            label.transform = CGAffineTransformMakeScale(scale, scale);
        }else {
            float distance = label.centerX-centerX;
            float multiple = distance/scrollView.width;
            float scale = MIN(MAX(1-multiple, ReduceTheRatio), 1);
            label.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    UILabel *label = self.sliderLabelArray[index];
    NSLog(@"index:%d centerX:%f label.centerX:%f",index,centerX,label.centerX);
    if (label.centerX == centerX) {
        label.textColor = [self getColor:@"EC630F" andAlpha:1];
        label.font = FONT(@"PingFangSC-Medium", 35);
        [self.delegate ScrollViewSliderAnimationDidChangeIndex:index];
    }
}

- (NSMutableArray *)sliderLabelArray{
    if (!_sliderLabelArray) {
        _sliderLabelArray = [NSMutableArray array];
    }
    return _sliderLabelArray;
}
- (void)setDefultIndex:(int)defultIndex{
    _defultIndex = defultIndex;
    [self.scrollview setContentOffset:CGPointMake(self.scrollview.width*_defultIndex, 0) animated:NO];
}
-( UIColor *) getColor:( NSString *)mkpColor andAlpha:(CGFloat)aplha

{
    unsigned int red, green, blue;
    
    NSRange range;
    
    range. length = 2 ;
    
    range. location = 0 ;
    
    [[ NSScanner scannerWithString :[mkpColor substringWithRange :range]] scanHexInt :&red];
    
    range. location = 2 ;
    
    [[ NSScanner scannerWithString :[mkpColor substringWithRange :range]] scanHexInt :&green];
    
    range. location = 4 ;
    
    [[ NSScanner scannerWithString :[mkpColor substringWithRange :range]] scanHexInt :&blue];
    
    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : aplha ];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
