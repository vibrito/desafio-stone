//
//  ViewController.h
//  Wallet Stone
//
//  Created by Vinicius Brito on 01/05/18.
//  Copyright © 2018 Vinicius Brito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldLogin;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

