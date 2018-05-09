//
//  BitcoinService.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "BitcoinService.h"
#import "AFHTTPSessionManager.h"

@implementation BitcoinService

+ (void)callServiceCotation:(NSString *)type onSuccess:(void (^)(Coin *coin))onSuccessBlock onFailure:(void (^)(NSError *error))onFailureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://www.mercadobitcoin.net/api/BTC/ticker/" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Coin *bitcoin = [[Coin alloc] init];
        NSDictionary *dictCoin = responseObject[@"ticker"];
        
        bitcoin.acronym = @"BTC";
        bitcoin.priceSell = [dictCoin[@"sell"] doubleValue];
        bitcoin.priceBuy = [dictCoin[@"buy"] doubleValue];
        bitcoin.name = @"Bitcoin";
        
        onSuccessBlock(bitcoin);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        onFailureBlock(error);
    }];
}

@end
