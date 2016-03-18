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
@property (weak, nonatomic) IBOutlet UIImageView *likedImageView;
@property (nonatomic) NSDictionary *likesDictionary;
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

- (IBAction)getLikesButtonTapped:(UIButton *)sender {

    [[PDKClient sharedInstance] getPath:@"/v1/me/likes/" parameters:nil withSuccess:^(PDKResponseObject *responseObject) {
        
        NSLog(@"Response Object: %@",responseObject.parsedJSONDictionary);
        self.likesDictionary = responseObject.parsedJSONDictionary;
        [self updateLikeImageView];

        
    } andFailure:^(NSError *error) {
        NSLog(@"Error fetching: %@",error.localizedDescription);
    }];
}

- (void)updateLikeImageView {
    
    NSString *link = [self linkFromDictionary:self.likesDictionary];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        NSURL *url = [NSURL URLWithString:link];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.likedImageView.image = image;
            
        });
        
    });
}

- (NSString *)linkFromDictionary:(NSDictionary *)dict {
    NSArray *data = dict[@"data"];
    NSDictionary *dictFromData = data[0];
    NSString *link = dictFromData[@"url"];
    
    return link;
}


@end
