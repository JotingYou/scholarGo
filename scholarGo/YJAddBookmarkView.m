//
//  YJAddBookmarkView.m
//  scholarGo
//
//  Created by 姚家庆 on 16/3/31.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJAddBookmarkView.h"
@interface YJAddBookmarkView()

@end
@implementation YJAddBookmarkView


-(IBAction)btnIsClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(YJAddBookmarkView:didClicked:)]) {
        [self.delegate YJAddBookmarkView:self didClicked:sender];
    }
}
-(instancetype)init{
    if (self=[super init]) {
        self=[[[NSBundle mainBundle]loadNibNamed:@"YJAddBookmark" owner:self options:nil]firstObject];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
