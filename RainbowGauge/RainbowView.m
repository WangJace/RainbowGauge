//
//  RainbowView.m
//  RainbowGauge
//
//  Created by 王傲云 on 16/4/11.
//  Copyright © 2016年 王傲云. All rights reserved.
//

#import "RainbowView.h"

#define RYUIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface RainbowView ()
{
    CAShapeLayer * _progressLayer;
    
}
@end

@implementation RainbowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self gradentWith:frame];    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self gradentWith];
        
    }
    return self;
}

- (void)gradentWith{
    NSLog(@"=-----%f",CGRectGetMidX(self.frame));
    
}

- (void)gradentWith:(CGRect)frame{
    //设置贝塞尔曲线
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(frame.size.width-PROGRESS_LINE_WIDTH)/2-5 startAngle:degressToRadius(-180) endAngle:degressToRadius(0) clockwise:YES];
    
    //遮罩层
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.lineWidth = PROGRESS_LINE_WIDTH+5;
    _progressLayer.path=path.CGPath;
    
    //渐变图层
    CALayer * grain = [CALayer layer];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width-0, self.bounds.size.height-0);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RYUIColorWithRGB(39, 75, 174) CGColor],(id)[RYUIColorWithRGB(75, 128, 107) CGColor], (id)[RYUIColorWithRGB(157, 202, 44) CGColor], (id)[RYUIColorWithRGB(231, 195, 43) CGColor], (id)[RYUIColorWithRGB(218, 19, 22) CGColor],nil]];
    [gradientLayer setLocations:@[@0,@0.25,@0.5,@0.75,@1]];
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    [grain addSublayer:gradientLayer];
    
    //用progressLayer来截取渐变层 遮罩
    [grain setMask:_progressLayer];
    [self.layer addSublayer:grain];
    
    
    //增加动画
    
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration = 6;
    
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    
    pathAnimation.autoreverses=NO;
    pathAnimation.repeatCount = INFINITY;
    //    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
