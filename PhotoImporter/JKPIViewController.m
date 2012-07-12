//
//  JKPIViewController.m
//  PhotoImporter
//
//  Created by Joseph Kain on 7/8/12.
//  Copyright (c) 2012 Joseph Kain. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAsset.h>

#import "JKPIViewController.h"

@interface JKPIViewController ()
- (void)fetchImages;
@end

@implementation JKPIViewController
@synthesize goButton = _goButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize greyOut = _greyOut;
@synthesize urlField = _urlField;

- (void) setBusy:(BOOL)busy
{
    isProcessing = busy;
    if (busy) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    self.goButton.enabled = !busy;
    self.greyOut.hidden = !busy;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setUrlField:nil];
    [self setGoButton:nil];
    [self setActivityIndicator:nil];
    [self setGreyOut:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button handle

- (IBAction)go:(id)sender
{
    // Fetch the data from the text fields
    url = self.urlField.text;
    
    // Dismiss the keyboard if present
    [self.urlField endEditing:YES];

    // busy
    self.busy = YES;
    
    // Kick off the fetch and store in a separate thread
    operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:
     [[NSInvocationOperation alloc] initWithTarget:self
                                          selector:@selector(fetchImages)
                                            object:nil]];
}

#pragma mark - thread handling
- (void) doneThread
{
    [operationQueue waitUntilAllOperationsAreFinished];
    operationQueue = nil;

    if (errorString) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorString
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        errorString = nil;
    }
    
    self.busy = NO;
}

- (void)fetchImages
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];

    int i;
    
    // This processes images from pi-instaweb
    for (i = 0; TRUE; i++) {
        NSString *fullPath = [NSString stringWithFormat:@"%@/%d", url, i];
       
        // Download each image
        NSURL *nsurl = [NSURL URLWithString:fullPath];
        NSData *data = [NSData dataWithContentsOfURL:nsurl];
        if (!data) {
            if (i == 0) {
                errorString = @"Could not download images";
            }
            break;
        }
                        
        // Write image to photos
        // This is assynchronous.  Wait for it to finish or it seems to overflow and then some of the images fail.
        __block BOOL done = NO;
        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                errorString = [error localizedDescription];
            }
            done = YES;
        }];
        while (!done);
    }

    // Let the main thread know this task is done
    [self performSelectorOnMainThread:@selector(doneThread) withObject:nil waitUntilDone:NO];
}

#pragma mark - UITextFieldDelegate

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // Disallow editing while processing
    return !isProcessing;
}

@end
