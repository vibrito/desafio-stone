//
//  Coin.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coin : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) double priceSell;
@property (nonatomic) double priceBuy;
@property (nonatomic, strong) NSString *acronym;

@end
