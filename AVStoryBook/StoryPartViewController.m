//
//  StoryPartViewController.m
//  AVStoryBook
//
//  Created by Nicolas Guerrero on 9/22/17.
//  Copyright © 2017 Nicolas Guerrero. All rights reserved.
//

#import "StoryPartViewController.h"
@import AVFoundation;

@interface StoryPartViewController ()

@property (nonatomic, strong) AVAudioFile *file;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;

@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cameraButtonClicked:(id)sender {
    
}

- (IBAction)microphoneButtonClicked:(id)sender {
    
}

@end
