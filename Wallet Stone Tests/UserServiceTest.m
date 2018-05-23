//
//  UserServiceTest.m
//  Wallet Stone Tests
//
//  Created by Vinicius Brito on 22/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserService.h"

#define kUserLoginSuccess    @"loginTestSucess"
#define kUserPasswordSuccess @"passwordTestSucess"
#define kUserNameSuccess     @"Test Success"

#define kUserLoginFail       @"Paçoca"
#define kUserPasswordFail    @"0"

@interface UserServiceTest : XCTestCase

@end

@implementation UserServiceTest

- (void)setUp
{
    [super setUp];
    
    User *user = [User new];
    user.name = kUserNameSuccess;
    user.login = kUserLoginSuccess;
    user.password = kUserPasswordSuccess;
    [[UserService sharedInstance] createUser:user];
    
    if ([[UserService sharedInstance] hasUserLogged])
    {
        [[UserService sharedInstance] doLogout];
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRegisterSuccess
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz1234567890";
    NSMutableString *randomLogin = [NSMutableString stringWithCapacity: 15];
    
    for (int i = 0; i < 15; i++)
    {
        [randomLogin appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    User *user = [User new];
    user.name = kUserNameSuccess;
    user.login = randomLogin;
    user.password = kUserPasswordSuccess;
    XCTAssertTrue([[UserService sharedInstance] createUser:user]);
}

- (void)testRegisterFail
{
    User *user = [User new];
    user.name = kUserNameSuccess;
    user.login = kUserLoginSuccess;
    user.password = kUserPasswordSuccess;
    XCTAssertFalse([[UserService sharedInstance] createUser:user]);
}

- (void)testLoginFail
{
    XCTAssertFalse([[UserService sharedInstance] doLogin:kUserLoginFail andPassword:kUserPasswordFail]);
}

- (void)testLoginSuccess
{
    NSString *login = kUserLoginSuccess;
    NSString *password = kUserPasswordSuccess;
    XCTAssertTrue([[UserService sharedInstance] doLogin:login andPassword:password]);
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
