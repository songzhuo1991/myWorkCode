//
//  AssociationalAndHistoryWordDisplayController.m
//  SuningEBuy
//
//  Created by chupeng on 13-12-19.
//  Copyright (c) 2013年 Suning. All rights reserved.
//

#import "AssociationalAndHistoryWordDisplayController.h"
#import <QuartzCore/QuartzCore.h>
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NewSearchViewController.h"
#define TXT_FONT 14.0
#define TXT_NORMALCOLOR RGBCOLOR(112, 112, 112)
#define BTNSHEIGHT 35.0
@interface AssociationalAndHistoryWordDisplayController ()
{
    UIViewController *__weak _contentController;
}


@property (nonatomic, weak) UIViewController *contentController;
@property (nonatomic, strong) NSArray *keywordList;

@property (nonatomic, strong) NSArray *keywordTypesList;

@end

@implementation AssociationalAndHistoryWordDisplayController

@synthesize service = _service;
@synthesize delegate = _delegate;
@synthesize displayTableView = _displayTableView;

@synthesize tableTopPosY = _tableTopPosY;
@synthesize distanceToTop = _distanceToTop;
@synthesize wordType = _wordType;
@synthesize contentController = _contentController;
@synthesize keywordList = _keywordList;

- (void)dealloc {
    SERVICE_RELEASE_SAFELY(_service);
    TT_RELEASE_SAFELY(_displayTableView);
    TT_RELEASE_SAFELY(_keywordList);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithContentController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        //        _tableTopPosY = 75;
        _tableTopPosY = 191; //add by wangjiaxing 20130517
        _distanceToTop = 64;
        _contentController = controller;
        _wordType = AssociationalWordMixType;
        self.displayTableView.frame = CGRectMake(0, _tableTopPosY, 320, 336);
        self.hotwordTableView.frame = CGRectMake(0, _tableTopPosY, 320, 336);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
#ifdef __IPHONE_5_0
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (version >= 5.0)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];

        }
#endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTypeChanged) name:SEARCHTYPE_CHANGED object:nil];
    }
    return self;
}

- (void)searchTypeChanged
{
    [self refreshViewWithKeyword:self.keyWord];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    height = screenHeight - 64 - keyboardRect.size.height;

        if ([self.contentController isKindOfClass:[NewSearchViewController class]])
        {
                self.backView.frame = CGRectMake(0, 44, 320, height);
                self.displayTableView.frame = CGRectMake(0, 44 + BTNSHEIGHT, 320, height - BTNSHEIGHT);
                self.hotwordTableView.frame = CGRectMake(0, 44 + BTNSHEIGHT, 320, height - BTNSHEIGHT);

        }
        else
        {
                self.backView.frame = CGRectMake(0, 64, 320, height);
                self.displayTableView.frame = CGRectMake(0, 64 + BTNSHEIGHT, 320, height - BTNSHEIGHT);
                self.hotwordTableView.frame = CGRectMake(0, 64 + BTNSHEIGHT, 320, height - BTNSHEIGHT);
            [self adjustTopSegment];
        }
    
}

- (void)setBShowingHistory:(BOOL)bShowingHistory
{
    if (_bShowingHistory != bShowingHistory)
    {
        _bShowingHistory = bShowingHistory;
    }
 
    [self adjustTopSegment];
}

- (void)adjustTopSegment
{
    int top = 64;
    
    
    
    if ([self.contentController isKindOfClass:[NewSearchViewController class]])
    {
        top = 44;
        
        //在搜索标签页，无键盘时候不改变各个tableview的frame
        if (height == 0)
            height = self.contentController.view.height;
    }
    else
    {
        if (IOS7_OR_LATER)
            top = 64;
        else
            top = 44;
    }
    if (_bShowingHistory)
    {
        self.topSegment.hidden = NO;
        
        self.backView.frame = CGRectMake(0, top, 320, height);
        self.displayTableView.frame = CGRectMake(0, top + BTNSHEIGHT, 320, height - BTNSHEIGHT);
        self.hotwordTableView.frame = CGRectMake(0, top + BTNSHEIGHT, 320, height - BTNSHEIGHT);
    }
    else
    {
        self.topSegment.hidden = YES;
        
        self.backView.frame = CGRectMake(0, top, 320, height);
        self.displayTableView.frame = CGRectMake(0, top, 320, height);
        self.hotwordTableView.frame = CGRectMake(0, top, 320, height);
        
    }

}


- (void)keyboardWillhide:(NSNotification *)notification
{
    [self hideViewsInNewSearchControl];
    height = 0;
}

- (void)hideViewsInNewSearchControl
{
    if ([self.contentController isKindOfClass:[NewSearchViewController class]])
    {
        self.bShowingHistory = YES;
        [self resetTopSegmentIndex];
        [UIView animateWithDuration:0.5 animations:^{
            self.backView.frame = CGRectMake(0, 44, 320, self.contentController.view.bounds.size.height - 64);
            self.displayTableView.frame = CGRectMake(0, 44 + BTNSHEIGHT, 320, self.contentController.view.bounds.size.height - 64 - BTNSHEIGHT);
            self.hotwordTableView.frame = CGRectMake(0, 44 + BTNSHEIGHT, 320, self.contentController.view.bounds.size.height - 64 - BTNSHEIGHT);
        }];
    }
}

- (UITableView *)displayTableView
{
    if(!_displayTableView){
		
		_displayTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                         style:UITableViewStylePlain];
		
		[_displayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		
		[_displayTableView setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
		
		_displayTableView.scrollEnabled = YES;
		
		_displayTableView.userInteractionEnabled = YES;
		
		_displayTableView.delegate =self;
		
		_displayTableView.dataSource =self;
        
        
        _displayTableView.backgroundColor = [UIColor whiteColor];
	}
	
	return _displayTableView;
}

- (UITableView *)hotwordTableView
{
    if (!_hotwordTableView) {
        
		_hotwordTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                         style:UITableViewStylePlain];
		
		[_hotwordTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		
		[_hotwordTableView setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
		
		_hotwordTableView.scrollEnabled = YES;
		
		_hotwordTableView.userInteractionEnabled = YES;
		
		_hotwordTableView.delegate =self;
		
        _hotwordTableView.layer.borderColor = [UIColor lightTextColor].CGColor;
        
		_hotwordTableView.dataSource =self;
		
		_hotwordTableView.backgroundColor = [UIColor whiteColor];//RGBCOLOR(239, 234, 216);
	}
	return _hotwordTableView;
}

- (UIView *)backView
{
    if (!_backView) {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.width;
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, screenHeight - 64 - 44)];
        
        [_backView addSubview:self.topSegment];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}


-(CustomSegment *)topSegment
{
    if (!_topSegment)
    {
        _topSegment = [[CustomSegment alloc] initWithFrame:CGRectMake(0, 0, 320, BTNSHEIGHT)];
        _topSegment.items = [NSArray arrayWithObjects:L(@"Search_SearchHistory"), L(@"Hot_Search"), nil];
        _topSegment.delegate = self;
    }
    return _topSegment;
}

- (void)segment:(CustomSegment *)segment didSelectAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        self.displayTableView.hidden = NO;
        self.hotwordTableView.hidden = YES;
    }
    else if (index == 1)
    {
        self.displayTableView.hidden = YES;
        self.hotwordTableView.hidden = NO;
    }
    [self.displayTableView reloadData];
    [self.hotwordTableView reloadData];
}


- (void)resetTopSegmentIndex
{
    [self.historyService getLatestTwentyKeywordsWithCompletionBlock:^(NSArray *list){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (list && list.count > 0)
            {
                self.topSegment.currentIndex = 0;
            }
            else
            {
                self.topSegment.currentIndex = 1;
            }
        });
    }];
}

-(void)displayView:(NSArray *)assicoateKeywords
{
//    self.topSegment.currentIndex = 0;
    [self resetTopSegmentIndex];
    
    self.hotWordsList = [NSMutableArray array];
    [self.hotWordsService beginGetHotKeywords];
    
    self.keywordList = assicoateKeywords;
    
    int searchType = [[Config currentConfig].searchType intValue];
    
    if (searchType == 1)
    {
        self.bShowingHistory = YES;

    }
    else if (searchType == 0)
    {
        self.bShowingHistory = NO;

    }

    if (self.displayTableView.superview == nil) {

        [UIView animateWithDuration:0.5 animations:^{
            //_tableTopPosY = 191;
            [self.contentController.view addSubview:self.backView];
            [self.contentController.view addSubview:self.displayTableView];
            [self.contentController.view addSubview:self.hotwordTableView];
            [self.contentController.view bringSubviewToFront:self.displayTableView];
        }];
        
    }
    [self.displayTableView reloadData];
    [self.hotwordTableView reloadData];
}

- (void)displayViewWithHistoryWords:(NSArray *)historyWords
{
    [self resetTopSegmentIndex];

    self.hotWordsList = [NSMutableArray array];
    [self.hotWordsService beginGetHotKeywords];
    
    self.historyKeywordsList = historyWords;
    self.bShowingHistory  = YES;

    if (self.displayTableView.superview == nil) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _tableTopPosY = 191;
            [self.contentController.view addSubview:self.backView];
            [self.contentController.view addSubview:self.displayTableView];
            [self.contentController.view addSubview:self.hotwordTableView];
            [self.contentController.view bringSubviewToFront:self.displayTableView];
        }];
        
    }
    [self.displayTableView reloadData];
    [self.hotwordTableView reloadData];

}

- (void)removeView
{
    if (self.displayTableView.superview) {
        [self.backView removeFromSuperview];
        [self.displayTableView removeFromSuperview];
        [self.hotwordTableView removeFromSuperview];
    }
}

#pragma mark -
#pragma mark table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.displayTableView)
    {
        if (!self.bShowingHistory)//联想词
            return 2;
        
        //历史
        return 1;
    }
    else if (tableView == self.hotwordTableView)
    {
        if (!self.hotWordsList || self.hotWordsList.count == 0)
        {
            return 0;
        }
        else
            return 2;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.displayTableView)
    {
        if (!self.bShowingHistory) //联想词
        {
            if (section == 0)
            {
                return self.keywordTypesList?[self.keywordTypesList count]:0;
            }
            else if (section == 1)
            {
                return self.keywordList?[self.keywordList count]:0;
            }
        }
        else
        {
            if (self.historyKeywordsList)
            {
                if (self.historyKeywordsList.count > 0)
                {
                    return self.historyKeywordsList.count + 1;
                }
                else
                    return 0;
            }
            else
            {
                return 0;
            }
        }
        
    }
    else if (self.hotwordTableView == tableView)
    {
        if (section == 0)
        {
            if (!self.hotWordsList || self.hotWordsList.count == 0)
            {
                return 0;
            }
            else
                return 1;
        }
        else if (section == 1)
        {
            return 1;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.displayTableView)
    {
        if (self.historyKeywordsList)
        {
            
            if (self.historyKeywordsList.count > 0 && indexPath.row == self.historyKeywordsList.count)
            {
                return 55;
            }
            
            return 39;
        }
        
        return 39;
        
    }
    else if (tableView == self.hotwordTableView)
    {
        if (indexPath.section == 0)
        {
            return 200;
        }
        else if (indexPath.section == 1)
        {
            return 40;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.displayTableView)
    {
        if (!self.bShowingHistory)
        {
            if (indexPath.section == 0)
            {
                static NSString *cellIdentifier = @"keywordTypesCell";
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                    
                    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(28, 9, 300, 20)];
                    [label setFont:[UIFont systemFontOfSize:TXT_FONT]];
                    label.backgroundColor = [UIColor clearColor];
                    label.tag = 100;
                    
                    UIImageView *cellSep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
                    cellSep.frame = CGRectMake(0, 38.5, 320, 0.5);
                    
                    [cell.contentView addSubview:cellSep];
                    [cell.contentView addSubview:label];
                }
                
                OHAttributedLabel *label = (OHAttributedLabel *)[cell.contentView viewWithTag:100];
                if (label && self.keywordTypesList)
                {
                    if (indexPath.row < self.keywordTypesList.count)
                    {
                        AssociationWordDTO *dto = (AssociationWordDTO *)[self.keywordTypesList objectAtIndex:indexPath.row];
                        
                        NSString *str = [NSString stringWithFormat:@"%@  %@  %@", L(@"Constant_In"),dto.dirName,L(@"Search_SearchInCategory")];
                        NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:str];
                        [mutaString setTextColor:TXT_NORMALCOLOR];
                        [mutaString setFont:[UIFont systemFontOfSize:TXT_FONT]];
                        [mutaString setTextColor:[UIColor colorWithRGBHex:0xf78100] range:[str rangeOfString:dto.dirName]];
                        
                        label.attributedText = mutaString;
                    }
                }
                return cell;
                
            }
            else if (indexPath.section == 1)
            {
                static NSString *cellIdentifier2 = @"keywordsCell";
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2];
                    cell.backgroundColor=[UIColor clearColor];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 9, 300, 20)];
                    label.font = [UIFont systemFontOfSize:TXT_FONT];
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = TXT_NORMALCOLOR;
                    label.tag = 100;
                    
                    [cell.contentView addSubview:label];
                }
                
                UILabel *label = (UILabel *)[cell viewWithTag:100];
                
                if (label)
                {
                    NSString *keyword = [self.keywordList objectAtIndex:indexPath.row];
                    label.text = keyword;
                }
                
                UIImageView *cellSep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
                cellSep.frame = CGRectMake(0, 38.5, 320, 0.5);
                [cell.contentView addSubview:cellSep];
                
                
                return cell;
                
            }
        }
        else
        {
            if (indexPath.section == 0)
            {
                if (indexPath.row < self.historyKeywordsList.count)
                {
                    static NSString *cellIdentifier = @"historyCell";
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                        cell.textLabel.font = [UIFont systemFontOfSize:TXT_FONT];
                        cell.textLabel.textColor = TXT_NORMALCOLOR;
                        
                        UIImageView *cellSep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
                        cellSep.frame = CGRectMake(0, 38.5, 320, 0.5);
                        
                        [cell.contentView addSubview:cellSep];
                    }
                    NSString *keyword = [NSString stringWithFormat:@"    %@",[self.historyKeywordsList objectAtIndex:indexPath.row] ];
                    cell.textLabel.text = keyword;
                    cell.textLabel.textColor=TXT_NORMALCOLOR;
                    
                    return cell;
                }
                else if (indexPath.row == self.historyKeywordsList.count)
                {
                    static NSString *cellIdentifier = @"clearHistoryCell";
                    
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((320 - 275) / 2, 10, 275, 35)];
                        [btn setTitleColor:RGBCOLOR(131, 131, 131) forState:UIControlStateNormal];
                        [btn setBackgroundColor:[UIColor whiteColor]];
                        [btn setTitle:L(@"Search_CleanSearchHistory") forState:UIControlStateNormal];
                        btn.layer.borderColor = RGBCOLOR(235, 235, 235).CGColor;
                        btn.layer.borderWidth = 1;
                        btn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [btn addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell.contentView addSubview:btn];
                        
                    }
                    
                    
                    return cell;
                }
            }
            
        }
    }
    else if (tableView == self.hotwordTableView)
    {
        if (indexPath.section == 0)
        {
            static NSString *hotWordCell = @"hotWordCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotWordCell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:hotWordCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.clipsToBounds = YES;
            }
            
            [cell.contentView removeAllSubviews];
            
            
            int x = 15, y = 15;
            
            for (int i = 0; i < self.hotWordsList.count; i++)
            {
                NSString *str = [self.hotWordsList objectAtIndex:i];
                CGSize sz = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(45, 20) lineBreakMode:NSLineBreakByTruncatingTail];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, sz.width + 50, 30)];
                btn.backgroundColor = [UIColor clearColor];
                [btn setTitleColor:RGBCOLOR(131, 131, 131) forState:UIControlStateNormal];
                btn.layer.borderColor = RGBCOLOR(235, 235, 235).CGColor;
                btn.layer.borderWidth = 1;
                [btn setTitle:str forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                btn.tag = i + 1;
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [btn addTarget:self action:@selector(btnHotWordTapped:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                
                x += sz.width + 60;
                if (x + 30 >= 290)
                {
                    x = 15;
                    y += 45;
                }
                
                
            }
            
            
            
            return cell;
            
        }
        else if (indexPath.section == 1)
        {
            static NSString *refreshCell = @"refreshHotWordCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:refreshCell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:refreshCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((320 - 275) / 2, 2.5, 275, 35)];
                [btn setTitleColor:RGBCOLOR(131, 131, 131) forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitle:L(@"Switch Hot keywords") forState:UIControlStateNormal];
                btn.layer.borderColor = RGBCOLOR(235, 235, 235).CGColor;
                btn.layer.borderWidth = 1;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn addTarget:self action:@selector(refreshHotWords) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:btn];

            }
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)refreshHotWords
{
    [SSAIOSSNDataCollection CustomEventCollection:@"click" keyArray: [NSArray arrayWithObjects:@"clickno", nil]valueArray: [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",@"840712"], nil]];
    [self.hotWordsService beginGetHotKeywords];
}


- (void)randomHotwordsList
{
    if (self.hotWordsList.count > 0)
    {
        int i = self.hotWordsList.count / 2;
        while (i) {
            int index1 = arc4random() % self.hotWordsList.count;
            int index2 = arc4random() % self.hotWordsList.count;
            [self.hotWordsList exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
            i--;
        }
    }
}

- (void)btnHotWordTapped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [SSAIOSSNDataCollection CustomEventCollection:@"click" keyArray: [NSArray arrayWithObjects:@"clickno", nil]valueArray: [NSArray arrayWithObjects:[NSString stringWithFormat:@"84070%d",btn.tag], nil]];
    NSString *url = [self getHotWordUrl:btn.titleLabel.text];
    if (IsStrEmpty(url))
    {
        searchTitle = @"hot";
        [self.delegate didSelectAssociationalWord:btn.titleLabel.text];
    }
    else
    {
        [self.delegate didSelectHotUrl:url bFromSearchView:YES wordOfUrl:btn.titleLabel.text];
//        [self.delegate didselectHotUrl:url];
    }
}


//通过点击的名称来查找对应的url
- (NSString *)getHotWordUrl:(NSString *)hotWord
{
    if (self.hotWordsService.hotWordDtoList && self.hotWordsService.hotWordDtoList.count > 0)
    {
        for (HotWordDTO *dto in self.hotWordsService.hotWordDtoList) {
            if ([dto.hotwordsStr isEqualToString:hotWord])
                return dto.urlStr;
        }
    }
    
    return nil;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.displayTableView)
    {
        if (!self.bShowingHistory)
            return NO;
        else if (self.historyKeywordsList)
        {
            if (indexPath.row == self.historyKeywordsList.count)
                return NO;
        }
    }
    else if (tableView == self.hotwordTableView)
        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (tableView == self.displayTableView)
    {
        if (!self.bShowingHistory)
            return;
        NSString *keyword = [self.historyKeywordsList objectAtIndex:indexPath.row];
        
        [self.historyService deleteKeywordFromDB:keyword completionBlock:^(NSArray *list){
            self.historyKeywordsList = list;
            [self.displayTableView reloadData];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteHistoryOk)])
            {
                [_delegate deleteHistoryOk];
            }
        }];
    }
    else if (tableView == self.hotwordTableView)
    {
        return;
    }
}

- (void)clearHistory:(id)sender
{
    BBAlertView *alert = [[BBAlertView alloc] initWithTitle:L(@"system-error")
                                                    message:L(@"Confirm clear search history")
                                                   delegate:nil
                                          cancelButtonTitle:L(@"Cancel")
                                          otherButtonTitles:L(@"confirm")];
    [alert setConfirmBlock:^{
        [SSAIOSSNDataCollection CustomEventCollection:@"click" keyArray: [NSArray arrayWithObjects:@"clickno", nil]valueArray: [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",@"840911"], nil]];
        [self.historyService deleteAllKeywordsFromDBWithCompletionBlock:^(NSArray *list){
            self.historyKeywordsList = list;
            [self.displayTableView reloadData];
        }];
    }];
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.displayTableView)
    {
        if (!self.bShowingHistory)
        {
            if (indexPath.section == 0)
            {
                if (self.keywordTypesList && indexPath.row < self.keywordTypesList.count)
                {
                    AssociationWordDTO *dto = (AssociationWordDTO *)[self.keywordTypesList objectAtIndex:indexPath.row];
                    if (_delegate && [_delegate respondsToSelector:@selector(didSelectAssociationalTypeKeyword:andDirId:andCore:)])
                    {
                        [_delegate didSelectAssociationalTypeKeyword:dto.keyWord andDirId:dto.dirId andCore:dto.core];
                    }
                }
            }
            else if (indexPath.section == 1)
            {
                NSString* str = @"8408";
                if (indexPath.row < 9)
                {
                    str = [NSString stringWithFormat:@"%@0%d",str,indexPath.row + 1];
                }
                else
                {
                    str = [NSString stringWithFormat:@"%@%d",str,indexPath.row + 1];
                }
                [SSAIOSSNDataCollection CustomEventCollection:@"click" keyArray: [NSArray arrayWithObjects:@"clickno", nil]valueArray: [NSArray arrayWithObjects:str, nil]];
                NSString *keyword = [self.keywordList objectAtIndex:indexPath.row];
                if (_delegate && [_delegate respondsToSelector:@selector(didSelectAssociationalWord:)]) {
                    searchTitle = @"rec";
                    [_delegate didSelectAssociationalWord:keyword];
                }
            }
        }
        else
        {
            if (!self.historyKeywordsList || self.historyKeywordsList.count == 0)
                return;
            if (indexPath.row >= self.historyKeywordsList.count)
                return;
            NSString* str = @"8409";
            if (indexPath.row < 9)
            {
                str = [NSString stringWithFormat:@"%@0%d",str,indexPath.row + 1];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@%d",str,indexPath.row + 1];
            }
            [SSAIOSSNDataCollection CustomEventCollection:@"click" keyArray: [NSArray arrayWithObjects:@"clickno", nil]valueArray: [NSArray arrayWithObjects:str, nil]];
            NSString *keyword = [self.historyKeywordsList objectAtIndex:indexPath.row];
            if (_delegate && [_delegate respondsToSelector:@selector(didSelectAssociationalWord:)]) {
                searchTitle = @"hist";
                [_delegate didSelectAssociationalWord:keyword];
            }
        }
    }
    else if (tableView == self.hotwordTableView)
    {
        return;
    }

}

#pragma mark -
#pragma mark service and delegate

- (AssociationalWordService *)service
{
    if (!_service) {
        _service = [[AssociationalWordService alloc] init];
        _service.delegate = self;
    }
    return _service;
}

- (SearchService *)historyService
{
    if (!_historyService)
    {
        _historyService = [[SearchService alloc] init];
        _historyService.delegate = self;
    }
    return _historyService;
}

- (SearchService *)hotWordsService
{
    if (!_hotWordsService)
    {
        _hotWordsService = [[SearchService alloc] init];
        _hotWordsService.delegate = self;
    }
    return _hotWordsService;
}

- (void)refreshViewWithKeyword:(NSString *)keyword
{
    self.keywordList = nil;
    self.historyKeywordsList = nil;
    self.keywordTypesList = nil;
    
//    self.topSegment.currentIndex = 0;
    [self resetTopSegmentIndex];
    [self.displayTableView reloadData];
    
    
    DLog(@"%@", keyword);

    
    int searchType = [[Config currentConfig].searchType intValue];
    if ([keyword isEmptyOrWhitespace] || keyword == nil)//此时显示历史搜索记录
    {
        self.keyWord = keyword;
        
        self.bShowingHistory = YES;

        
        [self.historyService getLatestTwentyKeywordsWithCompletionBlock:^(NSArray *list){
            self.historyKeywordsList = list;
            [self.displayTableView reloadData];
        }];
    }
    else
    {
        self.keyWord = keyword;
        
        if (searchType == 1)
        {
            self.bShowingHistory = YES;

            
            [self.historyService getLatestTwentyKeywordsWithCompletionBlock:^(NSArray *list){
                self.historyKeywordsList = list;
                [self.displayTableView reloadData];
            }];
            
            return;
        }
        else if (searchType == 0)
        {
            self.bShowingHistory = NO;

            
            [self.service beginGetAssociationalWordWithKeyword:keyword associationalWordType:self.wordType];
        }
    }
}

- (void)getAssociationalWordsCompletedWithResult:(BOOL)isSuccess errorMsg:(NSString *)errorMsg
{
    if (isSuccess) {
        self.keywordList = self.service.wordList;
        self.keywordTypesList = self.service.typesList;
        [self.displayTableView reloadData];
    }
}

- (void)getHotKeywordsCompleteWithService:(SearchService *)service
                                   Result:(BOOL)isSuccess
                                 errorMsg:(NSString *)errorMsg
{
    if (isSuccess) {
        self.hotWordsList = [service.hotKeywordList mutableCopy];
        self.hotWordsDtoList = [service.hotWordDtoList copy];
        [self.hotwordTableView reloadData];
        self.bGetHotWordsOK = TRUE;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshDefaultWords)])
        {
            [self.delegate refreshDefaultWords];
        }
    }else{
        self.bGetHotWordsOK = FALSE;
    }
}

@end
