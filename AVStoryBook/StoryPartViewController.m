//
//  StoryPartViewController.m
//  AVStoryBook
//
//  Created by Nicolas Guerrero on 9/22/17.
//  Copyright © 2017 Nicolas Guerrero. All rights reserved.
//

#import "StoryPartViewController.h"
#import "PageData.h"

@interface StoryPartViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;
@property (nonatomic, strong) PageData *pageData;

@end

@implementation StoryPartViewController

- (void)setPageIndex:(NSUInteger)pageIndex
{
    _pageIndex = pageIndex;
    self.pageData = [[PageData alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.pageData.audioFileURL = [[NSURL URLWithString:docPath]
                         URLByAppendingPathComponent:@"recording.m4a"];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapper:)];
    [self.imageView addGestureRecognizer:tap];
    self.imageView.userInteractionEnabled = YES;
}

#pragma mark Gesture Recognizer

-(void)tapper:(UITapGestureRecognizer *)sender{
    
    if ([self.pageData.audio isPlaying]) {
        [self.pageData.audio stop];
        return;
    }
    
    NSError *err = nil;
    self.pageData.audio = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:self.pageData.audioFileURL
                   error:&err];
    if (err != nil) {
        NSLog(@"Error creating player: %@", err.localizedDescription);
        abort();
    }
    
    [self.pageData.audio play];
    
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

#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"media info: %@", info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:^{    }];
}

#pragma mark Microphone Button - Record Audio

- (IBAction)microphoneButtonClicked:(id)sender {
    if ([self.pageData.recorder isRecording]) {
        [self.pageData.recorder stop];
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        return;
    }
    
    [sender setTitle:@"Stop" forState:UIControlStateNormal];
    
    NSError *err = nil;
    self.pageData.recorder = [[AVAudioRecorder alloc]
                     initWithURL:self.pageData.audioFileURL
                     settings:@{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                AVNumberOfChannelsKey: @(2),
                                AVSampleRateKey: @(44100)}
                     error:&err];
    if (err != nil) {
        NSLog(@"Error creating recorder: %@", err.localizedDescription);
        abort();
    }
    
    [self.pageData.recorder record];
}

@end
