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
}

- (IBAction)login:(id)sender
{
    if ([[UserService sharedInstance] doLogin:self.textFieldLogin.text andPassword:self.textFieldPassword.text])
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showMain];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alerta"
                                                                       message:@"Usuário não encontrado."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
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
