//
//  AppDelegate.h
//  DataSchool
//
//  Created by Bergren Lam on 15/12/1.
//  Copyright (c) 2015年 AlexChen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;
@class IIViewDeckController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;

- (IIViewDeckController*)generateControllerStack;

- (void)launchToMainPage;
- (void)launchToLogin;
- (void)setTanspNavigationAppearance:(UINavigationController *)nav;
- (void)setNormalNavigationAppearance:(UINavigationController *)nav;

@end

