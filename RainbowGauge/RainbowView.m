//
//  RainbowView.m
//  RainbowGauge
//
//  Created by 王傲云 on 16/4/11.
//  Copyright © 2016年 王傲云. All rights reserved.
//

#import "RainbowView.h"
#import "Triangle.h"

#define DegressToRadius(ang) (M_PI*(ang)/180.0f) //把角度转换成PI的方式
#define RYUIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define WIDTH CGRectGetWidth(self.frame)
#define HEIGHT CGRectGetHeight(self.frame)
#define PERSTRESSNEMBERDURATION 0.01

@interface RainbowView ()
{
    CAShapeLayer * _progressLayer;
    CALayer *_grain;
    CAGradientLayer *_gradientLayer;
    CGFloat _radius;
    
    CGFloat _preAngle;
    CGFloat _preNumber;
    CGPoint _circleCenter;
}

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) Triangle *triangle;

@end

@implementation RainbowView

- (instancetype)init
{
    if ((self = [super init])) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setSubView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateUI];
}

- (void)setSubView
{
    _triangleSide = 10;
    _numberLabelWidth = 30;
    _rainbowLineWidth = 5;
    
    _preNumber = 0;
    _preAngle = 0;
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = @"0";
    [self addSubview:_numberLabel];
    
    _triangle = [[Triangle alloc] init];
    _triangle.backgroundColor = [UIColor clearColor];
    [self addSubview:_triangle];
    
    //遮罩层
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    _progressLayer.lineCap = kCALineCapButt;
    
    //渐变图层
    _grain = [CALayer layer];
    _gradientLayer =  [CAGradientLayer layer];
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[RYUIColorWithRGB(39, 75, 174) CGColor],(id)[RYUIColorWithRGB(75, 128, 107) CGColor], (id)[RYUIColorWithRGB(157, 202, 44) CGColor], (id)[RYUIColorWithRGB(231, 195, 43) CGColor], (id)[RYUIColorWithRGB(218, 19, 22) CGColor],nil]];
    [_gradientLayer setLocations:@[@0,@0.25,@0.5,@0.75,@1]];
    [_gradientLayer setStartPoint:CGPointMake(0, 0)];
    [_gradientLayer setEndPoint:CGPointMake(1, 0)];
    [_grain addSublayer:_gradientLayer];
    
    //用progressLayer来截取渐变层 遮罩
    [_grain setMask:_progressLayer];
    [self.layer addSublayer:_grain];
}

- (void)updateUI
{
    if (WIDTH/2.0 > HEIGHT) {
        _radius = HEIGHT-_triangleSide*cos(M_PI/6)-_numberLabelWidth-_rainbowLineWidth;
    }
    else {
        _radius = WIDTH/2.0-_triangleSide*cos(M_PI/6)-_numberLabelWidth-_rainbowLineWidth;
    }
    
    _circleCenter = CGPointMake(WIDTH/2.0, HEIGHT);
    
    CGFloat x = WIDTH/2.0 - _radius - _rainbowLineWidth - _triangleSide*cos(M_PI/6) - _numberLabelWidth;
    _numberLabel.frame = CGRectMake(x, HEIGHT-_numberLabelWidth/2.0, _numberLabelWidth, _numberLabelWidth);
    _triangle.frame = CGRectMake(x+_numberLabelWidth, HEIGHT-_triangleSide/2.0, _triangleSide*cos(M_PI/6), _triangleSide);
    
    //设置贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_circleCenter radius:_radius startAngle:DegressToRadius(-180) endAngle:DegressToRadius(0) clockwise:YES];
    _progressLayer.frame = self.bounds;
    _progressLayer.lineWidth = _rainbowLineWidth*2;
    _progressLayer.path=path.CGPath;
    
    _gradientLayer.frame = CGRectMake(WIDTH/2.0-_radius-_rainbowLineWidth, 0, (_radius+_rainbowLineWidth)*2, HEIGHT);
}

- (void)setNumber:(NSInteger)number
{
    _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
    CGFloat angle = (number/100.0)*M_PI;
    CGFloat triangleRadius = _radius+_rainbowLineWidth+_triangleSide*cos(M_PI/6)/2.0;
    CGFloat numberLabelRadius = triangleRadius+_numberLabelWidth/2.0+5;
    
    CAAnimationGroup *triangleAnimation = [CAAnimationGroup animation];
    
    CAKeyframeAnimation *trianglePointAnimation = [CAKeyframeAnimation animation];
    trianglePointAnimation.keyPath = @"position";
    if (_preAngle > angle) {
        trianglePointAnimation.path = [UIBezierPath bezierPathWithArcCenter:_circleCenter radius:triangleRadius startAngle:_preAngle-DegressToRadius(180) endAngle:angle-DegressToRadius(180) clockwise:NO].CGPath;
    }
    else {
        trianglePointAnimation.path = [UIBezierPath bezierPathWithArcCenter:_circleCenter radius:triangleRadius startAngle:_preAngle-DegressToRadius(180) endAngle:angle-DegressToRadius(180) clockwise:YES].CGPath;
    }
    
    CAKeyframeAnimation *triangleRotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    triangleRotationAnimation.values = @[[NSNumber numberWithFloat:_preAngle], [NSNumber numberWithFloat:angle]];
    
    [triangleAnimation setAnimations:@[trianglePointAnimation,triangleRotationAnimation]];
    triangleAnimation.duration = fabs(number - _preNumber)*PERSTRESSNEMBERDURATION;
    triangleAnimation.removedOnCompletion = NO;
    triangleAnimation.fillMode = kCAFillModeForwards;
    [_triangle.layer addAnimation:triangleAnimation forKey:nil];
    
    CAKeyframeAnimation *numberLabelAnimation = [CAKeyframeAnimation animation];
    numberLabelAnimation.keyPath = @"position";
    numberLabelAnimation.duration = fabs(number -_preNumber)*PERSTRESSNEMBERDURATION;
    if (_preAngle > angle) {
        numberLabelAnimation.path = [UIBezierPath bezierPathWithArcCenter:_circleCenter radius:numberLabelRadius startAngle:_preAngle-DegressToRadius(180) endAngle:angle-DegressToRadius(180) clockwise:NO].CGPath;
    }
    else {
        numberLabelAnimation.path = [UIBezierPath bezierPathWithArcCenter:_circleCenter radius:numberLabelRadius startAngle:_preAngle-DegressToRadius(180) endAngle:angle-DegressToRadius(180) clockwise:YES].CGPath;
    }
    numberLabelAnimation.removedOnCompletion = NO;
    numberLabelAnimation.fillMode = kCAFillModeForwards;
    [_numberLabel.layer addAnimation:numberLabelAnimation forKey:nil];
    
    _preAngle = angle;
    _preNumber = number;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
