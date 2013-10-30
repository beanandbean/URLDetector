//
//  BBViewController.m
//  URLDetector
//
//  Created by wangsw on 10/24/13.
//  Copyright (c) 2013 beanandbean. All rights reserved.
//

#import "BBViewController.h"

#import "BBURLDetection.h"
#import "BBURLMatch.h"

@interface BBViewController ()

@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) BBURLMatch *currentMatch;

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"Welcome to URLDetector!";
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.view addSubview:label];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    
    self.textfield = [[UITextField alloc] init];
    self.textfield.placeholder = @"Text";
    self.textfield.translatesAutoresizingMaskIntoConstraints = NO;
    self.textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textfield.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self.textfield addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textfield];
    
    [self.textfield addConstraint:[NSLayoutConstraint constraintWithItem:self.textfield attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:44.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textfield attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textfield attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    
    self.label = [[UILabel alloc] init];
    self.label.numberOfLines = 0;
    self.label.text = @"URL: No URL found!";
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.view addSubview:self.label];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textfield attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textfield attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10.0]];
    
    UIView *tapHandler = [[UIView alloc] init];
    tapHandler.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:tapHandler belowSubview:self.label];

    [tapHandler addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapHandler attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapHandler attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapHandler attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapHandler attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange {
    NSString *trimmed = [self.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmed isEqualToString:@""]) {
        self.label.text = @"URL: No URL found!";
    } else {
        BBURLDetection *detection = [[BBURLDetection alloc] initWithString:self.textfield.text];
        if (detection.matches.count) {
            self.currentMatch = detection.matches.firstObject;
            self.label.text = [NSString stringWithFormat:@"URL: %@ (Press to enter)", self.currentMatch.URL];
        } else {
            self.currentMatch = nil;
            self.label.text = @"URL: No URL found!";
        }
    }
}

- (void)tapHandler {
    if (self.currentMatch) {
        NSURL *url = [NSURL URLWithString:self.currentMatch.URL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
