//
//  NewHomeTopView.h
//  SuningEBuy
//
//  Created by  zhang jian on 13-7-8.
//  Copyright (c) 2013年 Suning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonView.h"
#import "EightBannerView.h"
#import "NUSearchBar.h"
#import "SearchbarView.h"


@interface NewHomeTopView : CommonView<UISearchBarDelegate,UISearchDisplayDelegate,NUSearchBarDelegate>
{
    UIButton            *_cancelButton;
}
@property (nonatomic, strong) UIButton                  *cancelButton;//取消
@property (nonatomic, strong) EightBannerView           *topBannerView;       //八联版
@property (nonatomic, strong) UIButton                  *searchBtn;
//@property (nonatomic, retain) UISearchBar               *searchBar;
@property (nonatomic, strong) UIButton                  *readerButton;//扫一扫
@property (nonatomic, strong) SearchbarView             *searchBarView;

- (void)goToSearchView:(id)sender;
- (void)showSearchBar;
- (void)hideSearchBar:(UIButton *)btn;


@end
