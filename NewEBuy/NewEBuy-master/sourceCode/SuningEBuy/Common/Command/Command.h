//
//  Command.h
//  SuningEBuy
//
//  Created by  liukun on 12-11-16.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommandDelegate;
@protocol CommandDateSource;

//#ifdef NS_BLOCKS_AVAILABLE
typedef void (^CommandCallBackBlock)(id<CommandDateSource> cmd);
//#endif


@protocol CommandDateSource <NSObject>

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, weak) id<CommandDelegate> delegate;
@property (nonatomic, copy)   CommandCallBackBlock callBackBlock;

- (void)execute; //TODO doesn't need super
- (void)cancel;  //TODO need super;
- (void)done;

@end

@protocol CommandDelegate <NSObject>

@optional
- (void)commandDidFinish:(id<CommandDateSource>)cmd;
- (void)commandDidFailed:(id<CommandDateSource>)cmd;
@end



@interface Command : NSObject <CommandDateSource>

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, weak) id<CommandDelegate> delegate;
@property (nonatomic, copy)   CommandCallBackBlock callBackBlock;

+ (id)command;

- (void)execute;
- (void)cancel;
- (void)done;

@end
