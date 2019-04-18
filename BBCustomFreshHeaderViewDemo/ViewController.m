//
//  ViewController.m
//  BBCustomFreshHeaderViewDemo
//
//  Created by bonree on 2019/4/18.
//  Copyright © 2019 Bonree. All rights reserved.
//

#import "ViewController.h"
#import "BBCustomFreshHeaderView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tabeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeTop;
    __weak typeof(self)weakSelf = self;
    self.tabeView.mj_header = [BBCustomFreshHeaderView headerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tabeView.mj_header endRefreshing];
        });
    }];
}


@end
