//
//  ViewController.m
//  DataSchool
//
//  Created by Bergren Lam on 15/12/1.
//  Copyright (c) 2015年 AlexChen. All rights reserved.
//

#import "ViewController.h"
#import "IIViewDeckController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize popoverController = _popoverController2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)previewBounceLeftView {
    [self.viewDeckController previewBounceView:IIViewDeckLeftSide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
