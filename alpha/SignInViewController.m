//
//  SignInViewController.m
//  alpha
//
//  Created by Song, Yang on 2/19/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "SignInViewController.h"
#import "AmpacheFactory.h"

@interface SignInViewController()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) AmpacheFactory *service;

@end

@implementation SignInViewController
- (IBAction)submit:(id)sender {
    if(!_service) {
        _service = [AmpacheFactory sharedFactory];
    }
    Session *session = _service.session;
    User *user = session.user;
    user.username = [_username text];
    user.password = [_password text];
    BOOL result = [_service handShake];
    if(result) {
        NSLog(@"Log In Succeeded");
        [self performSegueWithIdentifier:@"signInSegue" sender:self];
    } else {
        NSLog(@"Log In Failed");
    }
}

@end
