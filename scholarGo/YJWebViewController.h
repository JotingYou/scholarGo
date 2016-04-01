//
//  YJWebViewController.h
//  freeBrowser
//
//  Created by 姚家庆 on 16/3/26.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJWebViewController;
@protocol YJWebViewControllerDelegate <NSObject>
@optional
-(void)YJWebViewController:(YJWebViewController*)webViewController;

@end
@interface YJWebViewController : UIViewController
@property (nonatomic,weak) id<YJWebViewControllerDelegate>delegate;

@property (nonatomic,copy) NSString *searchWords;
@end
