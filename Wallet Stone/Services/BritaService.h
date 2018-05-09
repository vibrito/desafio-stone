//
//  BritaService.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coin.h"

@interface BritaService : NSObject

+ (void)callServiceCotation:(NSString *)type onSuccess:(void (^)(Coin *coin))onSuccessBlock onFailure:(void (^)(NSError *error))onFailureBlock;

@end
