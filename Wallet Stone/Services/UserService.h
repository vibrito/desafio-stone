//
//  UserService.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Realm.h"

@interface UserService : NSObject

+ (UserService *) sharedInstance;
- (BOOL)createUser: (User *)user;
- (User *)getUserLogged;
- (BOOL)doLogin: (NSString *)login andPassword:(NSString *)password;
- (void)doLogout;
- (BOOL)hasUserLogged;

@end
