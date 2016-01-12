//
//  FMViewController.m
//  FMLibrary
//
//  Created by nicfzhou on 12/22/2015.
//  Copyright (c) 2015 nicfzhou. All rights reserved.
//

#import "FMViewController.h"
//#import "FMLibrary.h"
@import FMLibrary;

@interface FMViewController ()

@end

@implementation FMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [FZToast makeToast:@""];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [[GCDQueue mainQueue] execute:^{
        [self.view enableBlurry:YES];
        
        [self.view addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    } afterDelay:1];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
