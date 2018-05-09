//
//  User.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"
#import "UserCoin.h"

RLM_ARRAY_TYPE(UserCoin)
@interface User : RLMObject

@property NSString *name;
@property NSString *login;
@property NSString *password;
@property RLMArray<UserCoin *><UserCoin> *coins;
@property BOOL isLogged;

@end
