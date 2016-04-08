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
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIViewControllerPreviewingDelegate,YJWebViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (nonatomic,copy) NSString *searchWords;
@property (nonatomic,strong) NSMutableArray *favoriteWebsites;
@property (nonatomic,copy) NSString *plistPath;
//@property (nonatomic,strong) NSArray *PreActions;

@end

@implementation ViewController
#pragma mark -3DTouch 代理实现
//pop
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self performSegueWithIdentifier:@"toWebView" sender:self.searchWords];
}
//Peek
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{

    YJCollectionViewCell *cell=(YJCollectionViewCell *)[previewingContext sourceView];
    __weak typeof(self) wkSelf=self;
    UIViewController *vc=[UIViewController new];
    UIWebView *preWebView=[[UIWebView alloc]init];
    preWebView.scalesPageToFit=YES;
    vc.view=preWebView;
    wkSelf.searchWords=cell.website;
    NSString *url=[NSString stringWithFormat:@"http://%@",wkSelf.searchWords];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [preWebView loadRequest:request];
//    //上拉选项
//    UIPreviewAction *delete=[UIPreviewAction actionWithTitle:@"Delete" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        [wkSelf.favoriteWebsites removeObjectAtIndex:cell.tag];
//        [wkSelf.collectionView reloadData];
//        //模型转字典
//        NSMutableArray *arrayM=[NSMutableArray array];
//        for (YJFavoriteWebsite *website  in self.favoriteWebsites) {
//            NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[website.name,website.website,website.icon] forKeys:@[@"name",@"website",@"icon"]];
//            
//            
//            [arrayM addObject:dict];
//        }
//        //        NSLog(@"path=%@",self.plistPath);
//        [arrayM writeToFile:self.plistPath atomically:YES];
//
//    }];
//    UIPreviewAction *cancle=[UIPreviewAction actionWithTitle:@"Cancle" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        nil;
//    }];
//    wkSelf.PreActions=@[delete,cancle];
    return vc;
}
//-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
//{
//    return self.PreActions;
//}
//检测3D Touch是否可用

-(BOOL)is3DTouchAvailiable
{
    if(self.traitCollection.forceTouchCapability==UIForceTouchCapabilityAvailable){
        return YES;
    }
    return NO;
}

#pragma mark - *****懒加载*****

-(NSString *)plistPath{
    if (!_plistPath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        _plistPath=[doc stringByAppendingPathComponent:@"favoriteWebsite.plist"];
    }
    return  _plistPath;
}
//存放收藏网站信息
-(NSMutableArray *)favoriteWebsites{
    if (!_favoriteWebsites) {
        NSArray *arry=[NSArray arrayWithContentsOfFile:self.plistPath];
        if (!arry.count) {
            NSString *path=[[NSBundle mainBundle]pathForResource:@"favoriteWebsite.plist" ofType:nil];
            arry=[NSArray arrayWithContentsOfFile:path];
        }
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
    CGFloat gapX=(self.collectionView.frame.size.width-3*width)/4;
    CGFloat pointX=gapX*(indexPath.row%3+1)+indexPath.row%3*width;
    CGFloat pointY=gapY*(indexPath.row/3+1)+indexPath.row/3*height;
    cell.frame=CGRectMake(pointX, pointY, width, height);
    YJFavoriteWebsite *website=self.favoriteWebsites[indexPath.row];
    cell.webName.text=website.name;
    cell.webIcon.image=[UIImage imageNamed:website.icon];
    cell.website=website.website;
    cell.tag=indexPath.row;
    //注册3DTouch

    if([self is3DTouchAvailiable])
    {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }

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
//将屏幕变回竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait;
    
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
