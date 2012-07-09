//
//  JKPIViewController.m
//  PhotoImporter
//
//  Created by Joseph Kain on 7/8/12.
//  Copyright (c) 2012 Joseph Kain. All rights reserved.
//

#import "JKPIViewController.h"

@interface JKPIViewController ()

@end

@implementation JKPIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
