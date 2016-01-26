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

    
//    [FMPermission askPermissionOfType:PermissionTypePhoto complete:^(PermissionStatus status){
//        NSLog(@"permission status = %ld",(long)status);
//    }];
    
    [FMPermission askPermissionOfType:PermissionTypeLocationAlways complete:^(PermissionStatus status){
        NSLog(@"permission status = %ld",(long)status);
    }];
    
    
//    [FMPermission askPermissionOfType:PermissionTypeLocationAlways complete:^(PermissionStatus status){
//        NSLog(@"permission status = %ld",(long)status);
//    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
