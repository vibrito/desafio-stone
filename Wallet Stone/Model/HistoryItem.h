//
//  HistoryItem.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 09/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"

@interface HistoryItem : RLMObject

@property (nonatomic, strong) NSString *coinBought;
@property (nonatomic, strong) NSString *coinSold;
@property (nonatomic) double amountBought;
@property (nonatomic) double amountSold;
@property (nonatomic) NSDate *date;

@end
