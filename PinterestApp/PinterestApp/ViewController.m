//
//  ViewController.m
//  PinterestApp
//
//  Created by Mesfin Bekele Mekonnen on 3/17/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "ViewController.h"
#import "PDKUser.h"
#import <PinterestSDK/PinterestSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)authenticateButtonTapped:(UIButton *)sender {
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions,
                                                              PDKClientWritePublicPermissions,
                                                              PDKClientReadPrivatePermissions,
                                                              PDKClientWritePrivatePermissions,
                                                              PDKClientReadRelationshipsPermissions,
                                                              PDKClientWriteRelationshipsPermissions]
                                                withSuccess:^(PDKResponseObject *responseObject)
    {
        PDKUser *user = [responseObject user];
        NSLog(@"%@ authenticated!", user.firstName);
    } andFailure:^(NSError *error) {
        NSLog(@"authentication failed: %@", error);
    }];
}

@end
