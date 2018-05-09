//
//  UserService.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 08/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "UserService.h"

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
    //TODO: Criar usuário real
    //TODO: Conferir se o usuário já existe
    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    [User createOrUpdateInRealm:realm withValue:@{@"name": user.name, @"login": user.login, @"password": user.password, @"isLogged": @YES}];
//    [realm commitWriteTransaction];
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [User createOrUpdateInRealm:realm withValue:@{@"name": @"Vinícius Brito", @"login": @"vibrito@gmail.com", @"password": @"ad1bia", @"isLogged": @NO}];
    [realm commitWriteTransaction];
    
    return NO;
}

- (User *)getUserLogged
{
    RLMResults<User *> *user = [User objectsWhere:@"isLogged == true"];
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
