//
//  redView.m
//  动画
//
//  Created by 宋卓 on 16/4/28.
//  Copyright © 2016年 songzhuo. All rights reserved.
//

#import "redView.h"

@interface redView ()
@property (nonatomic, strong)IBOutlet UIView * whiteView;
@property (nonatomic, weak) UIButton * btn;
@end

@implementation redView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    CGPoint btnP = [self convertPoint:point toView:_btn];
//    if ([_btn pointInside:btnP withEvent:event]) {
//        return _btn;
//    }else{
//        return [super hitTest:point withEvent:event];
//    }
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s-----%@",__func__,[self class]);
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btn = btn;
//    btn.backgroundColor = [UIColor purpleColor];
//    [btn setBackgroundImage:[UIImage imageNamed:@"gift_category_guide"] forState:UIControlStateHighlighted];
//    btn.bounds = CGRectMake(0, 0, 200, 200);
//    btn.center = CGPointMake(100, -100);
//    [self addSubview:btn];
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
//    if (![self pointInside:point withEvent:event])return nil;
//    int count = (int)self.subviews.count;
//    for (int i = count - 1; i >= 0; i--) {
//        UIView *childView = self.subviews[i];
//        CGPoint childPoint = [self convertPoint:point toView:childView];
//        UIView *fitView = [childView hitTest:childPoint withEvent:event];
//        if (fitView) {
//            return fitView;
//        }
//    }
//    return self;
//}




- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint btnP = [self convertPoint:point toView:_whiteView];
    if ([_whiteView pointInside:btnP withEvent:event]) {
        
        
        return YES;
    }else{
    return [super pointInside:point withEvent:event];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
    CGFloat offsetX = curP.x - preP.x;
    CGFloat offsetY = curP.y - preP.y;
    CGPoint center = self.center;
    center.x += offsetX;
    center.y += offsetY;
    self.center = center;
    
    
}
@end
