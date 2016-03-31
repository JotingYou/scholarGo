//
//  YJFavoriteWebsite.m
//  freeBrowser
//
//  Created by 姚家庆 on 16/3/28.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJFavoriteWebsite.h"

@implementation YJFavoriteWebsite
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)favoriteWebsiteWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
@end
