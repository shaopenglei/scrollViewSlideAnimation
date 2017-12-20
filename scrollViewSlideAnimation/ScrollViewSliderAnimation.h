//
//  ScrollViewSliderAnimation.h
//  scrollViewSlideAnimation
//
//  Created by 邵朋磊 on 2017/12/7.
//  Copyright © 2017年 spl. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScrollViewSliderAnimationDelegate <NSObject>

-(void)ScrollViewSliderAnimationDidChangeIndex:(int)count;

@end

@interface ScrollViewSliderAnimation : UIView
/**
 *  数据数组
 */
@property (nonatomic,strong) NSArray *dataArray;
/**
 *  label的宽度
 */
@property(nonatomic,assign)float SliderLabelWidth;
/**
 *
 */
@property (nonatomic,strong) UIScrollView *scrollview;
/**
 *  用于储存label
 */
@property (nonatomic,strong) NSMutableArray *sliderLabelArray;
/**
 *  默认下标在第几个
 */
@property(nonatomic,assign)int defultIndex;
/**
 *
 */
@property (nonatomic,weak) id<ScrollViewSliderAnimationDelegate> delegate;
@end
