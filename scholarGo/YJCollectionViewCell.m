//
//  YJCollectionViewCell.m
//  freeBrowser
//
//  Created by 姚家庆 on 16/3/26.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJCollectionViewCell.h"
@interface YJCollectionViewCell()
@end
@implementation YJCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"YJCollectionViewCell" owner:self options:nil]firstObject];
    }
    return self;
}
-(instancetype)init{
    if (self=[super init]) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"YJCollectionViewCell" owner:self options:nil]firstObject];
    }
    return self;
}
@end
