//
//  HistoryViewController.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 03/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "HistoryViewController.h"
#import "UserService.h"

@interface HistoryViewController ()

@property (nonatomic, strong) User *user;


@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.user = [[UserService sharedInstance] getUserLogged];
    [self.tableViewHistory reloadData];
}

//MARK: Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.user.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"History";
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    HistoryItem *history = [HistoryItem new];
    history = self.user.history[indexPath.row];
    NSString *stringHistory = [NSString stringWithFormat:@"Compra de %.2f %@s com %@", history.amountBuyed, history.coinBuyed, history.coinSelled];
    
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:history.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterMediumStyle];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = stringHistory;
    cell.detailTextLabel.text = dateString;

    return cell;
}

@end
