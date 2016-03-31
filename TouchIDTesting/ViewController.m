//
//  ViewController.m
//  TouchIDTesting
//
//  Created by David Lindner on 9/28/15.
//  Copyright © 2015 David Lindner. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _textField.delegate = self;
    _textField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textSubmit:(id)sender {
    
    [self saveToKeychain: _textField.text];
    _textField.text = nil;
}

- (IBAction)authenticateButtonTapped1:(id)sender {
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                            if (error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"There was a problem verifying your identity."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                                  return;
                              }
                              
                              if (success) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                  message:@"You successfully authenticated to the device!"
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                                  
                              } else {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"You did not successfully authenticate to the device."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }
                              });
                              
                          }];
        
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


- (IBAction)authenticateButtonTapped2:(id)sender {
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self showLocalAuthenticationResult:success :error];
                              });
                              
                          }];
        
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (IBAction)authenticateButtonTapped3:(id)sender {
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                              if (error) {
                                  [self showError];
                                  return;
                              }
                              
                              if (success) {
                                  [self showSuccess];
                                  
                              } else {
                                  [self showError];
                                  return;
                              }
                              });
                              
                          }];
        
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)showLocalAuthenticationResult:(BOOL)success :(NSError*)error
{

    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"There was a problem verifying your identity."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"You successfully authenticated to the device!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You did not successfully authenticate to the device."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showError
{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"There was a problem verifying your identity."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        return;
}

- (void)showSuccess
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"You successfully authenticated to the device!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    return;
}

- (void)keychainButtonTapped:(id)sender {
    
    NSMutableDictionary *query = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                                   (__bridge id)kSecAttrService:@"TouchIDExample",
                                   (__bridge id)kSecReturnData:@YES,
                                   (__bridge id)kSecUseOperationPrompt: @"Authenticate to get password!"
                                   }.mutableCopy;
    CFDataRef dataRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&dataRef);
    if (status == errSecSuccess) {
        NSData * data =(__bridge NSData *)(dataRef);
        if(data == nil)
        {
            NSLog(@"Keychain data not found");
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Keychain Value"
                                                        message:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
            [alert show];
            return;
        }
    } else {
        
    }
    
}

- (void)saveToKeychain:(NSString*) passText {
    
    CFErrorRef error = NULL;
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                    kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                                    //kSecAccessControlTouchIDAny | kSecAccessControlDevicePasscode
                                                                    kSecAccessControlUserPresence, &error);
    NSDictionary *attributes = @{
                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                 (__bridge id)kSecAttrService: @"TouchIDExample",
                                 (__bridge id)kSecValueData: [passText dataUsingEncoding:NSUTF8StringEncoding],
                                 (__bridge id)kSecUseNoAuthenticationUI: @YES,
                                 (__bridge id)kSecAttrAccessControl: (__bridge_transfer id)sacObject
                                 };
    
    //dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        OSStatus initialWriteStatus =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        if (initialWriteStatus == errSecSuccess) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"You successfully saved to keychain!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        } else if (initialWriteStatus == errSecDuplicateItem ||
                   initialWriteStatus == errSecInteractionNotAllowed) {
            [self deleteExisting];
           // dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
                OSStatus initialWriteStatus =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
                if (initialWriteStatus == errSecSuccess) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"You successfully saved to keychain!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Cannot save to keychain."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            //});
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:[NSString stringWithFormat:@"%d",initialWriteStatus]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
   // });
}

- (void)deleteExisting {
    NSDictionary *query = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:@"TouchIDExample"
                            };
    //dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
        if (status == errSecSuccess) {
            return;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Having problems deleting password."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    
    //});
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_textField endEditing:YES];
}


@end
