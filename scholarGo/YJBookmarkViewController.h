//
//  YJBookmarkViewController.h
//  scholarGo
//
//  Created by 姚家庆 on 16/3/30.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJBookmarkViewController;
@protocol YJBookmarkViewControllerDelegate <NSObject>
@optional
-(void)YJBookmarkViewController:(YJBookmarkViewController*)bookmarkController withWebsite:(NSString*)website;

@end
@interface YJBookmarkViewController : UIViewController
@property (nonatomic,copy) NSString *currentWebsite;
@property (nonatomic,weak) id<YJBookmarkViewControllerDelegate>delegate;

@end
