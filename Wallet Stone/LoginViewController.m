//
//  ViewController.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 01/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UserService sharedInstance] createUser:nil];
}

- (IBAction)login:(id)sender
{
    //TODO: alterar para o login real
    if ([[UserService sharedInstance] doLogin:@"vibrito@gmail.com" andPassword:@"ad1bia"])
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showMain];
    }
//    if ([[UserService sharedInstance] doLogin:self.textFieldLogin.text andPassword:self.textFieldPassword.text])
//    {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate showMain];
//    }
    else
    {
        NSLog(@"Usuário não encontrado");
    }
}

- (IBAction)signup:(id)sender
{
    [self performSegueWithIdentifier:@"SegueSignup" sender:self];
}

- (IBAction)forget:(id)sender
{
    //TODO: implementar o esqueci senha
}

@end
