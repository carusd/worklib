//
//  GTRecorder.m
//  iGuitar
//
//  Created by carusd on 15/8/13.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import "GTRecorder.h"
#import "GTConstants.h"
#import <UIKit/UIKit.h>
NSString * const GTRecorderDoneNotification = @"GTRecorderDoneNotification";
NSString * const GTRecorderDoneNotificationUserInfoKey = @"GTRecorderDoneNotificationUserInfoKey";

@interface GTRecorder ()<AVAudioRecorderDelegate>

@end

@implementation GTRecorder

+ (instancetype)sharedInstance {
    static GTRecorder *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GTRecorder alloc] init];
    });
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self ensureAudiosPath];
    }
    
    return self;
}

- (NSString *)audiosPath {
    return _audiosPath;
}

- (void)ensureAudiosPath {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    _audiosPath = [NSString stringWithFormat:@"%@/audios", cacheDir];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_audiosPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_audiosPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)startRecording {
    NSString *filepath = nil;
    if (GTIOSVersion >= 8) {
        filepath = [NSString stringWithFormat:@"%@/%f.aac", self.audiosPath, CFAbsoluteTimeGetCurrent()];
    } else {
        filepath = [NSString stringWithFormat:@"%@/%f.m4a", self.audiosPath, CFAbsoluteTimeGetCurrent()];
    }
    
    NSError *e = nil;
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filepath] settings:recordSetting error:&e];
    _audioRecorder.delegate = self;
    [_audioRecorder record];
}

- (void)stopRecording {
    [_audioRecorder stop];
}

- (void)pauseRecording {
    [_audioRecorder pause];
}

- (BOOL)recording {
    return _audioRecorder.recording;
}

#pragma mark recorder delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    if (self.recordSuccess) {
        self.recordSuccess(recorder.url);
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GTRecorderDoneNotification object:nil userInfo:@{GTRecorderDoneNotificationUserInfoKey: _audioRecorder.url}];
    
    _audioRecorder.delegate = nil;
    _audioRecorder = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    
}


@end
