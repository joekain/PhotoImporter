//
//  JKPIViewController.h
//  PhotoImporter
//
//  Created by Joseph Kain on 7/8/12.
//  Copyright (c) 2012 Joseph Kain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKPIViewController : UIViewController <UITextFieldDelegate> {
    NSString *url;
    NSString *group;
    NSOperationQueue *operationQueue;
    bool isProcessing;
}

@property (strong, nonatomic) IBOutlet UITextField *urlField;
@property (strong, nonatomic) IBOutlet UITextField *groupField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *greyOut;

- (IBAction)go:(id)sender;

@end
