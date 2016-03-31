//
//  YJWebViewController.m
//  freeBrowser
//
//  Created by 姚家庆 on 16/3/26.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJWebViewController.h"
#import "MBProgressHUD+HM.h"
#define kSearchUrl @"https://m.baidu.com/s?word"
@interface YJWebViewController ()<UIWebViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
//判断页面是否正在加载
@property (nonatomic,assign,getter=isloading) BOOL loading;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gobackBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goforwardBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (nonatomic,strong) NSURLRequest *currentRequest;
//判断当前请求否是输入框输入内容发起
@property (nonatomic,assign,getter=isSearchByAddressText) BOOL searchByAddressText;

@end

@implementation YJWebViewController
//-(NSString *)searchWords{
//    if (!_searchWords) {
//        _searchWords=[[NSString alloc]init];
//    }
//    return _searchWords;
//}
#pragma mark - toolbar Action
- (IBAction)goBack:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];

        
    }
    
}
- (IBAction)goForward:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
    
}
- (IBAction)refresh:(id)sender {
    if (self.isloading) {
        //若正在加载 显示停止
        //NSLog(@"停止加载");
        [self.webView stopLoading];
        self.loading=NO;
        self.refreshBtn.image=[UIImage imageNamed:@"refresh"];
    }else{
        //若加载完毕 显示刷新
        //NSLog(@"重新加载");
       [self.webView reload];
    }
    
    
}
- (IBAction)goHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addToBookmarks:(id)sender {
//    YJBookmarkView *bookmarkView=[[YJBookmarkView alloc]init];
//    bookmarkView.bounds=CGRectMake(0, 0, 30, 50);
//    [self.view addSubview:bookmarkView];
//    bookmarkView.translatesAutoresizingMaskIntoConstraints=NO;
//    [bookmarkView addConstraint:[NSLayoutConstraint constraintWithItem:bookmarkView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
}
- (IBAction)share:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =[NSString stringWithFormat:@"%@",[self.currentRequest URL]];
    [MBProgressHUD showSuccess:@"网址已复制到剪切板"];
    
}
#pragma mark - webView 代理方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.loading=NO;
    self.refreshBtn.image=[UIImage imageNamed:@"refresh"];
    if ([self.webView canGoForward]) {
        self.goforwardBtn.enabled=YES;
    }else{
        self.goforwardBtn.enabled=NO;
    }
    if ([self.webView canGoBack]) {
        self.gobackBtn.enabled=YES;
    }else{
        self.gobackBtn.enabled=NO;
    }
    self.searchByAddressText=NO;
    //NSLog(@"加载完成");
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.webView canGoForward]) {
        self.goforwardBtn.enabled=YES;
    }else{
        self.goforwardBtn.enabled=NO;
    }
    if ([self.webView canGoBack]) {
        self.gobackBtn.enabled=YES;
    }else{
        self.gobackBtn.enabled=NO;
    }

    self.refreshBtn.image=[UIImage imageNamed:@"stop"];
    self.loading=YES;
    //NSLog(@"开始加载");
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (self.isSearchByAddressText) {
        self.searchByAddressText=NO;
        //解析关键词
        NSCharacterSet *set=[NSCharacterSet URLHostAllowedCharacterSet];
        self.searchWords=[self.searchWords stringByAddingPercentEncodingWithAllowedCharacters:set];
        //添加搜索引擎地址
        NSString *url=[NSString stringWithFormat:@"%@=%@",kSearchUrl,self.searchWords];
        //NSLog(@"self.searchWords=%@",self.searchWords);
        //NSLog(@"url=%@",url);
        

        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
        //NSLog(@"使用搜索引擎加载");
    }else{
        [MBProgressHUD showError:@"连接失败，请检查网络"];
        //NSLog(@"加载失败，error=%@",error);
    }
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //仅显示简单链接
    self.searchTxt.text=[NSString stringWithFormat:@"%@",[request URL].host];
    self.currentRequest=request;
    return YES;
}
#pragma mark - textField 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchWords=self.searchTxt.text;
    NSString *url=[NSString stringWithFormat:@"http://%@",self.searchWords];
    if ([url isEqualToString:@"http://"]) {
        return YES;
    }
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    self.searchByAddressText=YES;
    [self.searchTxt endEditing:YES];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //显示详细地址
    self.searchTxt.text=[NSString stringWithFormat:@"%@",[self.currentRequest URL]];
    self.searchTxt.textColor=[UIColor blackColor];

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //显示简单地址
    self.searchTxt.text=[NSString stringWithFormat:@"%@",[self.currentRequest URL].host];
    self.searchTxt.textColor=[UIColor darkGrayColor];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.toolbar.hidden=YES;
}
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    self.toolbar.hidden=NO;
}
#pragma mark - 主程序
- (void)viewDidLoad {
    [super viewDidLoad];

        NSString *url=[NSString stringWithFormat:@"http://%@",self.searchWords];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.searchByAddressText=YES;
        [self.webView loadRequest:request];
    [self.searchTxt setAutocapitalizationType:UITextAutocapitalizationTypeNone];


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
