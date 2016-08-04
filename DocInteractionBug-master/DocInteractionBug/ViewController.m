//
//  ViewController.m
//  DocInteractionBug
//
//  Created by birdseye on 4/30/14.
//  Copyright (c) 2014 esgie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:NULL];
  for (NSString *fileName in files) {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
  
    if ([[path pathExtension] isEqualToString:@"docx"]) {
      self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
      self.documentInteractionController.delegate = self;
      self.documentInteractionController.UTI = @"public.plain-text";
      self.documentInteractionController.name = @"详细设计说明书";
    }
  }
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.userInteractionEnabled = YES;
  button.frame = CGRectMake((CGRectGetWidth(self.view.bounds) / 2) - 100, (CGRectGetHeight(self.view.bounds) / 2) - 50, 200, 100);
  button.backgroundColor = [UIColor darkGrayColor];
  [button addTarget:self action:@selector(displayDoc) forControlEvents:UIControlEventTouchUpInside];
  [button setTitle:@"display" forState:UIControlStateNormal];
  button.titleLabel.textColor = [UIColor whiteColor];
  [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
  return self;
}

- (void)displayDoc
{
  [self.documentInteractionController presentPreviewAnimated:YES];
}

@end
