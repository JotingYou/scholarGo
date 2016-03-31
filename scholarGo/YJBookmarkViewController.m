//
//  YJBookmarkViewController.m
//  scholarGo
//
//  Created by 姚家庆 on 16/3/30.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJBookmarkViewController.h"
#import "YJFavoriteWebsite.h"
@interface YJBookmarkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UITextField *websiteAddressTxt;
@property (weak, nonatomic) IBOutlet UITextField *webNameTxt;
@property (nonatomic,strong) NSMutableArray *favoriteWebsites;
@end

@implementation YJBookmarkViewController
#pragma mark - 懒加载
-(NSMutableArray *)favoriteWebsites{
    if (!_favoriteWebsites) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"favoriteWebsite.plist" ofType:nil];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayM=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            YJFavoriteWebsite *model=[YJFavoriteWebsite favoriteWebsiteWithDictionary:dict];
            [arrayM addObject:model];
        }
        _favoriteWebsites=arrayM;
    }
    return _favoriteWebsites;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark - tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favoriteWebsites.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"bookmarkCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    YJFavoriteWebsite *website=self.favoriteWebsites[indexPath.row];
    cell.textLabel.text=website.name;
    cell.detailTextLabel.text=website.website;
    return cell;
}
#pragma mark - toolbar动作
- (IBAction)add:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        self.addView.alpha=0.6;
    } completion:^(BOOL finished) {
        self.addView.alpha=1;
        self.addView.hidden=NO;
    }];
    
    
    
}
- (IBAction)finish:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - addView动作
- (IBAction)addBookmark:(id)sender {
    NSLog(@"添加成功");
}
- (IBAction)cancleAdd:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        self.addView.alpha=0;
    } completion:^(BOOL finished) {
        self.addView.hidden=YES;
    }];
   
}

#pragma mark - 主程序
- (void)viewDidLoad {
    self.addView.hidden=YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
