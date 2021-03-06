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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)buySell:(id)sender
{
    [self buy];
}

- (void)buy
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    UserCoin *cointToSpend = self.user.coins[_indexCoin];
    
    NSString* stringDouble = [self.textFieldAmount.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    double amountToBuy = [stringDouble doubleValue];
    double amountToSell = self.coin.priceSell * [self.textFieldAmount.text doubleValue];
    
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
    else
    {
        if (amountToSell <= cointToSpend.amount * cointToSpend.priceSell)
        {
            double newAmount = cointToSpend.amount - (amountToSell / cointToSpend.priceSell);
            BOOL hasCoin = NO;
            UserCoin *coinToOp = [UserCoin new];
            
            for (UserCoin *coin in self.user.coins)
            {
                if ([coin.acronym isEqualToString:self.coin.acronym])
                {
                    coinToOp = coin;
                    hasCoin = YES;
                }
            }
            
            if (hasCoin == YES)
            {
                [realm beginWriteTransaction];
                cointToSpend.amount = newAmount;
                coinToOp.amount = amountToBuy + coinToOp.amount;
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
            
            HistoryItem *history = [HistoryItem new];
            history.coinBought = self.coin.name;
            history.coinSold = cointToSpend.name;
            history.amountSold = amountToSell;
            history.amountBought = amountToBuy;
            history.date = [NSDate date];
            [realm beginWriteTransaction];
            cointToSpend.amount = newAmount;
            [self.user.history addObject:history];
            [realm commitWriteTransaction];
            
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
}

//https://stackoverflow.com/a/4850969/2859731
//MARK: Text Field Methods
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    static NSString *numbers = @"0123456789";
    static NSString *numbersPeriod = @"01234567890.";
    static NSString *numbersComma = @"0123456789,";
    
    //NSLog(@"%d %d %@", range.location, range.length, string);
    if (range.length > 0 && [string length] == 0)
    {
        // enable delete
        return YES;
    }
    
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    if (range.location == 0 && [string isEqualToString:symbol])
    {
        // decimalseparator should not be first
        return NO;
    }
    NSCharacterSet *characterSet;
    NSRange separatorRange = [textField.text rangeOfString:symbol];
    if (separatorRange.location == NSNotFound)
    {
        if ([symbol isEqualToString:@"."])
        {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersPeriod] invertedSet];
        }
        else
        {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersComma] invertedSet];
        }
    }
    else
    {
        // allow 2 characters after the decimal separator
        if (range.location > (separatorRange.location + 2))
        {
            return NO;
        }
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    }
    return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
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

- (void)dismissKeyboard
{
    [self.textFieldAmount resignFirstResponder];
}

@end
