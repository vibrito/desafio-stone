//
//  HistoryViewController.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 03/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewHistory;

@end
