//
//  JZAACEncoder.h
//  DS
//
//  Created by Zhen on 2016/11/20.
//  Copyright © 2016年 Zhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface JZAACEncoder : NSObject

@property (nonatomic) dispatch_queue_t encoderQueue;
@property (nonatomic) dispatch_queue_t callbackQueue;

/*
    步骤: 
     1、设置编码器（codec），并开始录制；
     2、收集到PCM数据，传给编码器；
     3、编码完成回调callback，写入文件。
 */
- (void) encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer completionBlock:(void (^)(NSData *encodedData, NSError* error))completionBlock;

@end
