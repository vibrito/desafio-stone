//
//  WalletViewController.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 03/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "WalletViewController.h"
#import "AFHTTPSessionManager.h"
#import "Coin.h"
#import "BitcoinService.h"
#import "BritaService.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "UserService.h"
#import "MBProgressHUD.h"
#import "OperationsViewController.h"

#import "User.h"
 
@interface WalletViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrayCoins;
@property (nonatomic, strong) NSMutableArray *arrayUserCoins;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) User *user;

@end

@implementation WalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayCoins = [NSMutableArray new];
    self.arrayUserCoins = [NSMutableArray new];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableViewWallet addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(callCotations) forControlEvents:UIControlEventValueChanged];
    
    [self callCotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.user = [[UserService sharedInstance] getUserLogged];
    self.arrayUserCoins = [NSMutableArray new];
    for (RLMObject *object in self.user.coins)
    {
        UserCoin *comment = [[UserCoin alloc] initWithValue:object];
        [self.arrayUserCoins addObject:comment];
    }
    
    [self.tableViewWallet reloadData];
}

- (void)callCotations
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    //TODO: Criar uma fila para só atualizar no fim do download
    if (reach.isReachable)
    {
        self.arrayCoins = [[NSMutableArray alloc] init];
        
        [BritaService callServiceCotation:@"" onSuccess:^(Coin *coin) {
            [self.arrayCoins addObject:coin];
            [self endRefresh];
        } onFailure:^(NSError *error) {
            [self endRefresh];
        }];
        
        [BitcoinService callServiceCotation:@"" onSuccess:^(Coin *coin) {
            [self.arrayCoins addObject:coin];
            [self endRefresh];
        } onFailure:^(NSError *error) {
            [self endRefresh];
        }];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alerta"
                                                                       message:@"Sem conexão"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* reloadAction = [UIAlertAction actionWithTitle:@"Tentar de novo" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {[self callCotations];}];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [alert addAction:reloadAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)endRefresh
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
    [self.tableViewWallet reloadData];
    [self.refreshControl endRefreshing];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if  ([segue.identifier isEqualToString:@"SegueBuySell"])
    {
        NSIndexPath *index = sender;
        OperationsViewController *vc = [segue destinationViewController];
        if  (index.section == 1)
        {
            vc.coin = self.arrayCoins[index.row];
        }
        else
        {
            vc.coin = self.arrayUserCoins[index.row];
        }
    }
}

- (IBAction)logout:(id)sender
{
    [[UserService sharedInstance] doLogout];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLogin];
}

//MARK: Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Suas moedas";
    }
    
    return @"Cotações";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"Valor das cotações acima estão em Reais.";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.arrayUserCoins.count;
    }
    else
    {
        return self.arrayCoins.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"YourCoins";
        UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UserCoin *coin = self.arrayUserCoins[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %.2f", coin.acronym, coin.amount];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Quotation";
        UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        Coin *coin = self.arrayCoins[indexPath.row];
        cell.textLabel.text = coin.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %.2f", coin.acronym, coin.priceSell];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueBuySell" sender:indexPath];
}

@end
