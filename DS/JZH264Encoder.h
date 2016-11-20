//
//  JZH264Encoder.h
//  DS
//
//  Created by Zhen on 2016/11/20.
//  Copyright © 2016年 Zhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@protocol JZH264EncoderDelegate <NSObject>

- (void)gotSpsPps:(NSData*)sps pps:(NSData*)pps;
- (void)gotEncodedData:(NSData*)data isKeyFrame:(BOOL)isKeyFrame;

@end

@interface JZH264Encoder : NSObject

- (void)initWithConfiguration;
- (void)start:(int)width  height:(int)height;
- (void)initEncode:(int)width  height:(int)height;
- (void)encode:(CMSampleBufferRef )sampleBuffer;
- (void)End;

@property (weak, nonatomic) NSString *error;
@property (weak, nonatomic) id<JZH264EncoderDelegate> delegate;

@end
