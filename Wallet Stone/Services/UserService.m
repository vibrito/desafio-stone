//
//  UserService.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "UserService.h"
#import "UserCoin.h"

@implementation UserService

+ (UserService *)sharedInstance
{
    static UserService *sharedObject = nil;
    @synchronized(self)
    {
        if (sharedObject == nil)
        {
            sharedObject = [[self alloc] init];
        }
    }
    return sharedObject;
}

- (BOOL)createUser: (User *)user
{
    //Checa se o login já foi cadastrado
    NSString *stringLogin = [NSString stringWithFormat:@"login ==[c] '%@'", user.login];
    RLMResults<User *> *userCheck = [User objectsWhere:stringLogin];
    if (userCheck.count > 0)
    {
        return NO;
    }
    
    User *newUser = [User new];
    UserCoin *real = [UserCoin new];
    real.acronym = @"BRL";
    real.priceSell =  1;
    real.priceBuy =  1;
    real.name = @"Real";
    real.amount = 100000;
    [newUser.coins addObject:real];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [User createOrUpdateInRealm:realm withValue:@{@"name": user.name, @"login": user.login, @"password": user.password, @"isLogged": @YES, @"coins": newUser.coins}];
    [realm commitWriteTransaction];
    
    return YES;
}

- (User *)getUserLogged
{
    RLMResults<User *> *user = [User objectsWhere:@"isLogged == 1"];
    if (user.count > 0)
    {
        User *userLogged = user[0];
        return userLogged;
    }
    
    return nil;
}

- (BOOL)doLogin: (NSString *)login andPassword:(NSString *)password;
{
    NSString *stringLogin = [NSString stringWithFormat:@"login ==[c] '%@'", login];
    RLMResults<User *> *user = [User objectsWhere:stringLogin];
    
    if (user.count > 0)
    {
        User *userLogin = user[0];
        if ([userLogin.password isEqualToString:password])
        {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [User createOrUpdateInRealm:realm withValue:@{@"login": login, @"isLogged": @YES}];
            [realm commitWriteTransaction];
            
            return YES;
        }
    }
    
    return NO;
}

- (void)doLogout
{
    User *userLogged = [self getUserLogged];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [User createOrUpdateInRealm:realm withValue:@{@"login": userLogged.login, @"isLogged": @NO}];
    [realm commitWriteTransaction];
}

- (BOOL)hasUserLogged
{
    if ([self getUserLogged] == nil)
    {
        return NO;
    }
    
    return YES;
}

@end
