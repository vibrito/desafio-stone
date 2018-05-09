//
//  OperationsViewController.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 09/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coin.h"

@interface OperationsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) Coin *coin;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAmount;
@property (weak, nonatomic) IBOutlet UIButton *buttonBuySell;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCoins;

- (IBAction)buySell:(id)sender;

@end
