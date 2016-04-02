//
//  main.m
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AmpacheFactory.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        /*AmpacheFactory *service = [AmpacheFactory sharedFactory];
        service.session.user.username = @"admin";
        service.session.user.password = @"123";
        BOOL result = [service handShake];
        if(result) {
            NSLog(@"Hand shake successful");
        } else {
            NSLog(@"Hand shake failed");
        }
        [service getSongs];
        NSLog(@"Songs are %@", [service getSongs]);*/
    }
}
