//
//  ViewController.h
//  TestPageTableView
//
//  Created by liujing on 8/18/16.
//  Copyright © 2016 liujing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) IBOutlet UITableView *tableView;

@end

