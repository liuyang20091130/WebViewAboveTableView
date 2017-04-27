//
//  ViewController.m
//  H5NADemo
//
//  Created by Liu,Yang on 2017/4/27.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    NSURLRequest *requtst = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://po.baidu.com/feed/share?isBdboxShare=1&context=%7B%22nid%22%3A%22news_10252661440349564034%22%7D"]];
    [_webView loadRequest:requtst];
    
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@  %@",keyPath, change);
    if (object == _webView && [keyPath isEqualToString:@"scrollView.contentSize"]) {
        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        self.webViewHeightConstraint.constant = MIN(size.height, self.webView.superview.frame.size.height);
    }
    if (object == _tableView && [keyPath isEqualToString:@"contentSize"]) {
        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        self.tableViewHeightConstraint.constant = MIN(size.height, self.tableView.superview.frame.size.height);
    }
    
    
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize size = webView.scrollView.contentSize;
    self.webViewHeightConstraint.constant = MIN(size.height, self.webView.superview.frame.size.height);
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"   %ld ",(long)indexPath.row];
    return cell;
}



@end
