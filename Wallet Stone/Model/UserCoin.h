//
//  UserCoin.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 09/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"

@interface UserCoin : RLMObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) double priceSell;
@property (nonatomic) double priceBuy;
@property (nonatomic, strong) NSString *acronym;
@property (nonatomic) double amount;

@end
