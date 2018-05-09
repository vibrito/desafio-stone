//
//  WalletViewController.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 03/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableViewWallet;

@end
