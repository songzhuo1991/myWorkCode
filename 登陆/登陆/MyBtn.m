//
//  MyBtn.m
//  登陆
//
//  Created by 宋卓 on 15/12/10.
//  Copyright © 2015年 songzhuo. All rights reserved.
//

#import "MyBtn.h"

@implementation MyBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}
@end
