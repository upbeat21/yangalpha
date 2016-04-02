//
//  AppDelegate.h
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) PlayerViewController *pvc;


@end

