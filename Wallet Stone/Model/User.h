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
#import "HistoryItem.h"

RLM_ARRAY_TYPE(UserCoin)
RLM_ARRAY_TYPE(HistoryItem)

@interface User : RLMObject

@property NSString *name;
@property NSString *login;
@property NSString *password;
@property RLMArray<UserCoin *><UserCoin> *coins;
@property RLMArray<HistoryItem *><HistoryItem> *history;
@property BOOL isLogged;

@end
