//
//  RegisterViewController.m
//  Wallet Stone
//
//  Created by Vinicius Brito on 01/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserService.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

//MARK: Actions
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)register:(id)sender
{
    [self dismissKeyboard];
    
    if ([self checkTextField:self.textFieldLogin.text] == false|| [self checkTextField: self.textFieldPassword.text] == false|| [self checkTextField: self.textFieldName.text] == false)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alerta"
                                                                       message:@"Um ou mais campos não parecem corretos"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        User *user = [User new];
        user.name = self.textFieldName.text;
        user.password = self.textFieldPassword.text;
        user.login = self.textFieldLogin.text;

        if ([[UserService sharedInstance] createUser:user])
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate showMain];
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alerta"
                                                                           message:@"Usuário já cadastrado."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (BOOL)checkTextField: (NSString *)string
{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([trimmedString isEqualToString:@""] || trimmedString.length < 6)
    {
        return false;
    }
    
    return true;
}

//MARK: TextField Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textFieldLogin.isFirstResponder)
    {
        [self.textFieldPassword becomeFirstResponder];
    }
    else if (self.textFieldPassword.isFirstResponder)
    {
        [self.textFieldName becomeFirstResponder];
    }
    else
    {
        [self register:nil];
    }
    
    return YES;
}

- (void)dismissKeyboard
{
    [self.textFieldLogin resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    [self.textFieldName resignFirstResponder];
}

@end
