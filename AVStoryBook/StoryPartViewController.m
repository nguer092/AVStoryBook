//
//  StoryPartViewController.m
//  AVStoryBook
//
//  Created by Nicolas Guerrero on 9/22/17.
//  Copyright © 2017 Nicolas Guerrero. All rights reserved.
//

#import "StoryPartViewController.h"
#import "PageData.h"
@import AVFoundation;

@interface StoryPartViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audio;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) NSURL *audioFileURL;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;

@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.audioFileURL = [[NSURL URLWithString:docPath]
                         URLByAppendingPathComponent:@"recording.m4a"];
    
    // Do any additional setup after loading the view.
    self.imageView.userInteractionEnabled = YES;
    
//    PageData *instance = [[PageData alloc] init];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapper:)];
    [self.imageView addGestureRecognizer:tap];
}

#pragma mark Gesture Recognizer

-(void)tapper:(UITapGestureRecognizer *)sender{
    
    if ([self.audio isPlaying]) {
        [self.audio stop];
        return;
    }
    
    NSError *err = nil;
    self.audio = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:self.audioFileURL
                   error:&err];
    if (err != nil) {
        NSLog(@"Error creating player: %@", err.localizedDescription);
        abort();
    }
    
    [self.audio play];
    
}

#pragma mark - Camera Button

- (IBAction)cameraButtonClicked:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    picker.mediaTypes = mediaTypes;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

//UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"media info: %@", info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:^{    }];
}

#pragma mark Microphone Button - Record Audio

- (IBAction)microphoneButtonClicked:(id)sender {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        return;
    }
    [sender setTitle:@"Stop" forState:UIControlStateNormal];
    
    NSError *err = nil;
    self.recorder = [[AVAudioRecorder alloc]
                     initWithURL:self.audioFileURL
                     settings:@{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                AVNumberOfChannelsKey: @(2),
                                AVSampleRateKey: @(44100)}
                     error:&err];
    if (err != nil) {
        NSLog(@"Error creating recorder: %@", err.localizedDescription);
        abort();
    }
    [self.recorder record];
}

@end
