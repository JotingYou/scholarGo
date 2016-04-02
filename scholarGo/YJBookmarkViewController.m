//
//  YJBookmarkViewController.m
//  scholarGo
//
//  Created by 姚家庆 on 16/3/30.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJBookmarkViewController.h"
#import "YJFavoriteWebsite.h"
#import "YJAddBookmarkView.h"
@interface YJBookmarkViewController ()<UITableViewDelegate,UITableViewDataSource,YJAddBookmarkViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//存放plist文件地址
@property (nonatomic,copy) NSString *plistPath;
@property (nonatomic,strong) NSMutableArray *favoriteWebsites;
@property (nonatomic,strong) YJAddBookmarkView *addView;

@end

@implementation YJBookmarkViewController
#pragma mark - 懒加载
-(NSString *)plistPath{
    if (!_plistPath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        _plistPath=[doc stringByAppendingPathComponent:@"favoriteWebsite.plist"];
    }
    return  _plistPath;
}
-(NSMutableArray *)favoriteWebsites{
    if (!_favoriteWebsites) {
        

        NSArray *array=[NSArray arrayWithContentsOfFile:self.plistPath];
        if (!array.count) {
            self.plistPath=[[NSBundle mainBundle]pathForResource:@"favoriteWebsite.plist" ofType:nil] ;
            array=[NSArray arrayWithContentsOfFile:self.plistPath];
        }
        NSMutableArray *arrayM=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            YJFavoriteWebsite *model=[YJFavoriteWebsite favoriteWebsiteWithDictionary:dict];
            [arrayM addObject:model];
        }
        _favoriteWebsites=arrayM;
    }
    return _favoriteWebsites;
}
-(YJAddBookmarkView *)addView{
    if (!_addView) {
        _addView=[[YJAddBookmarkView alloc]init];
        _addView.bounds=CGRectMake(0,0, 300, 150);
        _addView.websiteTxt.text=self.currentWebsite;
        _addView.delegate=self;
    }
    return _addView;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJFavoriteWebsite *website=self.favoriteWebsites[indexPath.row];

    [self dismissViewControllerAnimated:YES completion:^{if ([self.delegate respondsToSelector:@selector(YJBookmarkViewController:withWebsite:)]) {
        [self.delegate YJBookmarkViewController:self withWebsite:website.website];
    }
    }];
    

}
//设置编辑类型
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    [self.favoriteWebsites removeObjectAtIndex:indexPath.row];
    NSMutableArray *arrayM=[NSMutableArray array];
    for (YJFavoriteWebsite *website  in self.favoriteWebsites) {
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[website.name,website.website,website.icon] forKeys:@[@"name",@"website",@"icon"]];
        
        
        [arrayM addObject:dict];
    }
    //写入文件
    [arrayM writeToFile:self.plistPath atomically:YES];
    //重新加载
    [self.tableView reloadData];
}
#pragma mark - toolbar动作
- (IBAction)add:(id)sender {

    
    [self.view addSubview:self.addView];
    [self.addView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:300]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:150]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.addView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}
- (IBAction)finish:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - addView动作
-(void)YJAddBookmarkView:(YJAddBookmarkView *)addView didClicked:(UIButton *)button{
    if (button.tag) {
        //添加
        
        YJFavoriteWebsite *newWeb=[[YJFavoriteWebsite alloc]init];
        newWeb.website=addView.websiteTxt.text;
        newWeb.name=addView.webNameTxt.text;
        newWeb.icon=@"w";
        [self.favoriteWebsites addObject:newWeb];
        //模型转字典
        NSMutableArray *arrayM=[NSMutableArray array];
        for (YJFavoriteWebsite *website  in self.favoriteWebsites) {
            NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[website.name,website.website,website.icon] forKeys:@[@"name",@"website",@"icon"]];
            
            
            [arrayM addObject:dict];
        }
//        NSLog(@"path=%@",self.plistPath);
        [arrayM writeToFile:self.plistPath atomically:YES];
        
//        NSLog(@"添加成功");
        //重新加载
        [self.tableView reloadData];
        [addView removeFromSuperview];
    }else{
        [addView removeFromSuperview];

        //取消
    }
}


#pragma mark - 主程序
- (void)viewDidLoad {
    
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
