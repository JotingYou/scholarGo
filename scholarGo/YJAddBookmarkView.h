//
//  YJAddBookmarkView.h
//  scholarGo
//
//  Created by 姚家庆 on 16/3/31.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJAddBookmarkView;
@protocol YJAddBookmarkViewDelegate <NSObject>
@optional
-(void)YJAddBookmarkView:(YJAddBookmarkView*)addView didClicked:(UIButton *)button;

@end
@interface YJAddBookmarkView : UIView
@property (weak, nonatomic) IBOutlet UITextField *websiteTxt;
@property (weak, nonatomic) IBOutlet UITextField *webNameTxt;
@property (nonatomic,weak) id<YJAddBookmarkViewDelegate>delegate;

@property (nonatomic,copy) NSString *website;
@property (nonatomic,copy) NSString *webName;

@end
