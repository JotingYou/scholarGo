//
//  ViewController.m
//  freeBrowser
//
//  Created by 姚家庆 on 16/3/26.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "ViewController.h"
#import "YJCollectionViewCell.h"
#import "YJWebViewController.h"
#import "YJFavoriteWebsite.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,YJWebViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (nonatomic,strong) NSMutableArray *favoriteWebsites;

@end

@implementation ViewController

#pragma mark - *****懒加载*****
-(NSMutableArray *)favoriteWebsites{
    if (!_favoriteWebsites) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path=[doc stringByAppendingPathComponent:@"favoriteWebsite.plist"];

        NSArray *arry=[NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arryM=[NSMutableArray array];
        
        for (NSDictionary *dict in arry) {
            YJFavoriteWebsite *model=[YJFavoriteWebsite favoriteWebsiteWithDictionary:dict];
            [arryM addObject:model];
        }
        _favoriteWebsites=arryM;
    }
    return _favoriteWebsites;
}

#pragma mark -collectionView代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *dequeID=@"YJWebCell";
    YJCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:dequeID forIndexPath:indexPath];
    if (!cell) {
        cell=[[YJCollectionViewCell alloc]init];
    }
    
    CGFloat gapY=20;
    CGFloat width=95;
    CGFloat height=110;
    CGFloat gapX=([[UIScreen mainScreen]bounds].size.width-3*width)/4;
    CGFloat pointX=gapX*(indexPath.row%3+1)+indexPath.row%3*width;
    CGFloat pointY=gapY*(indexPath.row/3+1)+indexPath.row/3*height;
    
    cell.frame=CGRectMake(pointX, pointY, width, height);
    YJFavoriteWebsite *website=self.favoriteWebsites[indexPath.row];
    cell.webName.text=website.name;
    cell.webIcon.image=[UIImage imageNamed:website.icon];
    cell.backgroundView.backgroundColor=[UIColor blackColor];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.favoriteWebsites.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YJFavoriteWebsite *website=self.favoriteWebsites[indexPath.row];
    [self performSegueWithIdentifier:@"toWebView" sender:website.website];
}
#pragma mark - 主程序
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchTxt setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.collectionView registerClass:[YJCollectionViewCell class] forCellWithReuseIdentifier:@"YJWebCell"];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVC=segue.destinationViewController;
    if ([destVC isKindOfClass:[YJWebViewController class]]) {
        YJWebViewController *webVC=destVC;
        webVC.delegate=self;
        webVC.searchWords=sender;
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self performSegueWithIdentifier:@"toWebView" sender:self.searchTxt.text];
    self.searchTxt.text=nil;
    return YES;
}
//关闭自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - YJWebViewController代理方法
-(void)YJWebViewController:(YJWebViewController *)webViewController{
    //清除缓存
    self.favoriteWebsites=nil;
    //重新加载
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
