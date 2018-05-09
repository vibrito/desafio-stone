//
//  WalletViewController.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 03/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

//MM-DD-AAAA
//https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)?%40dataCotacao=%2705-07-2018%27&%24format=json

//https://www.mercadobitcoin.net/api/BTC/ticker/

#import "WalletViewController.h"
#import "AFHTTPSessionManager.h"
#import "Coin.h"
#import "BitcoinService.h"
#import "BritaService.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "UserService.h"

#import "User.h"
 
@interface WalletViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrayCoins;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation WalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayCoins = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableViewWallet addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(callCotations) forControlEvents:UIControlEventValueChanged];
    
    [self callCotations];
}

- (void)callCotations
{
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];

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
    [self.tableViewWallet reloadData];
    [self.refreshControl endRefreshing];
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
        return 1;
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
        
        cell.textLabel.text = @"R$ 100000";
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
        
        Coin *coin = self.arrayCoins[indexPath.row];
        cell.textLabel.text = coin.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %.2f", coin.acronym, coin.priceSell];
        
        return cell;
    }
}

@end
