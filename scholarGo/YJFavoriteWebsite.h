//
//  YJFavoriteWebsite.h
//  freeBrowser
//
//  Created by 姚家庆 on 16/3/28.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJFavoriteWebsite : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *website;
@property (nonatomic,copy) NSString *icon;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
+(instancetype)favoriteWebsiteWithDictionary:(NSDictionary *)dict;


@end
