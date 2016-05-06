//
//  CommonBarButtonItem.m
//  SNFramework
//
//  Created by  liukun on 13-12-27.
//  Copyright (c) 2013年 liukun. All rights reserved.
//

#import "SNUIBarButtonItem.h"

@implementation SNUIBarButtonItem
+ (instancetype)itemWithTitle:(NSString *)title
                        Style:(SNNavItemStyle)style
                       target:(id)target
                       action:(SEL)action
{
    if (style == SNNavItemStyleBack)
    {
        //返回
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:@"nav_back_normal.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"nav_back_select.png"] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(0, 0, 44, 44);
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);

        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        SNUIBarButtonItem *item = [[SNUIBarButtonItem alloc] initWithCustomView:btn];
        return item;
    }
    else if (style == SNNavItemStyleDone)
    {
        
            SNUIBarButtonItem *item = [[SNUIBarButtonItem alloc]
                                       initWithTitle:title
                                       style:UIBarButtonItemStylePlain
                                       target:target
                                       action:action];
            [item setTitlePositionAdjustment:UIOffsetMake(-5, 0) forBarMetrics:UIBarMetricsDefault];
            item.tintColor = [UIColor colorWithRGBHex:0xfc7c26];
            return item;
        
    }
    else
    {
        return nil;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if ([self.customView isKindOfClass:[UIControl class]])
    {
        UIControl *ctrl = (UIControl *)self.customView;
        ctrl.enabled = enabled;
    }
}

@end
