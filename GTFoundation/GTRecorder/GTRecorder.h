//
//  GTRecorder.h
//  iGuitar
//
//  Created by carusd on 15/8/13.
//  Copyright (c) 2015年 GuitarGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString * const GTRecorderDoneNotification;
extern NSString * const GTRecorderDoneNotificationUserInfoKey;

typedef void(^GTRecordSuccess)(NSURL *fileURL);
typedef void(^GTRecordFailure)(void);

@interface GTRecorder : NSObject {
    NSString *_audiosPath;
    AVAudioRecorder *_audioRecorder;
}

+ (instancetype)sharedInstance;

- (void)startRecording;
- (void)stopRecording;
- (void)pauseRecording;
- (BOOL)recording;

@property (nonatomic, copy) GTRecordSuccess recordSuccess;
@property (nonatomic, copy) GTRecordFailure failure;

@end
