//
//  OperationsViewController.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 09/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "OperationsViewController.h"
#import "UserService.h"

@interface OperationsViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic) NSInteger indexCoin;

@end

@implementation OperationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.coin.name;
    self.indexCoin = 0;
    self.user = [[UserService sharedInstance] getUserLogged];
}

- (IBAction)buySell:(id)sender
{
    [self buy];
}

- (void)buy
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    UserCoin *cointToSpend = self.user.coins[_indexCoin];
    
    double amountToBuy = [self.textFieldAmount.text doubleValue];
    double amountToSpend = self.coin.priceSell * [self.textFieldAmount.text doubleValue];
    
    

    if ([cointToSpend.acronym isEqualToString:self.coin.acronym] || [self.textFieldAmount.text isEqualToString:@""])
    {
        NSString * stringAlert = @"As moedas de compra e venda são iguais. Por favor escolha outra.";
        
        if ([self.textFieldAmount.text isEqualToString:@""])
        {
            stringAlert = @"Preencha o valor da compra";
        }
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alerta"
                                                                       message:stringAlert
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (amountToSpend <= cointToSpend.amount * cointToSpend.priceSell)
    {
        double newAmount = cointToSpend.amount - (amountToSpend / cointToSpend.priceSell);
        
        NSString *coinAcr = [NSString stringWithFormat:@"acronym ==[c] '%@'", self.coin.acronym];
        RLMResults<UserCoin *> *coinToOp = [UserCoin objectsWhere:coinAcr];
        
        if (coinToOp.count > 0)
        {
            [realm beginWriteTransaction];
            cointToSpend.amount = newAmount;
            coinToOp[0].amount = amountToBuy + coinToOp[0].amount;
            [realm commitWriteTransaction];
        }
        else
        {
            UserCoin *newCoin = [UserCoin new];
            newCoin.acronym = self.coin.acronym;
            newCoin.priceSell =  self.coin.priceSell;
            newCoin.priceBuy =  self.coin.priceBuy;
            newCoin.name = self.coin.name;
            newCoin.amount = amountToBuy;
            
            [realm beginWriteTransaction];
            cointToSpend.amount = newAmount;
            [self.user.coins addObject:newCoin];
            [realm commitWriteTransaction];
        }
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sucesso"
                                                                       message:@"Compra efetuada com sucesso."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self.navigationController popViewControllerAnimated:YES];}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alerta"
                                                                       message:@"Valor insuficiente para a compra."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//MARK: Picker Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.user.coins.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UserCoin *userCoin = self.user.coins[row];
    return userCoin.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.indexCoin = row;
}

@end
