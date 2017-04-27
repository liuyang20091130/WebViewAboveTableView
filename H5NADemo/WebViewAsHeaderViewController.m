//
//  WebViewAsHeaderViewController.m
//  H5NADemo
//
//  Created by Liu,Yang on 2017/4/27.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "WebViewAsHeaderViewController.h"

@interface WebViewAsHeaderViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WebViewAsHeaderViewController

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    self.webView = webView;
    
    self.tableView.tableHeaderView = self.webView;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSURLRequest *requtst = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://po.baidu.com/feed/share?isBdboxShare=1&context=%7B%22nid%22%3A%22news_10252661440349564034%22%7D"]];
    [_webView loadRequest:requtst];
    
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}
- (IBAction)btnClick:(UIButton *)sender {
    NSURLRequest *requtst = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [_webView loadRequest:requtst];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@  %@",keyPath, change);
    if (object == _webView && [keyPath isEqualToString:@"scrollView.contentSize"]) {
        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        if (size.height != self.webView.frame.size.height) {
            self.webView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, size.height);
            [self.tableView reloadData];
        }
        
    }
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s",__func__);
    //获取webiew内容高度
    CGFloat oldHeight = webView.frame.size.height;
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    CGFloat newHeight = fittingSize.height;
    if (oldHeight != newHeight) {
        frame.size.height = newHeight;
        self.webView.frame = frame;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"   %ld ",(long)indexPath.row];
    return cell;
}


@end
