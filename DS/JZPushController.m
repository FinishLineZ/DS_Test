//
//  JZPushController.m
//  DS
//
//  Created by aj on 2016/11/10.
//  Copyright © 2016年 Zhen. All rights reserved.
//

#import "JZPushController.h"
#import "LFLiveKit.h"

@interface JZPushController ()<LFLiveSessionDelegate>

@property (nonatomic, strong) UIView *myView;

@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, copy  ) NSString *rtmpUrl;


@end

@implementation JZPushController
- (UIView *)myView {
    
    if(!_myView) {
        UIView *livingPreView = [[UIView alloc] initWithFrame:self.view.bounds];
        livingPreView.backgroundColor = [UIColor clearColor];
        livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:livingPreView atIndex:0];
        _myView = livingPreView;
    }
    return _myView;
}

- (LFLiveSession*)session{
    if(!_session){
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High3]];
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration liveType:LFLiveRTMP];
         */
        
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.myView;
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myView];
    
    if(![self checkPrivacyAuthrity]) {
        NSLog(@"无权限");
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    // 本地推流地址rtmp://120.76.46.224/live
    stream.url = @"rtmp://120.76.46.224/live";
    self.rtmpUrl = stream.url;
    [self.session startLive:stream];
}

#pragma mark - 权限相关

- (BOOL)checkPrivacyAuthrity {
    
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSLog(@"您的设备没有摄像头或者相关的驱动, 不能进行直播");
        return NO;
    }
    //判断是否有摄像头权限
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        NSLog(@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头");
        return NO;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                return YES;
            }
            else {
                NSLog(@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风");
                return NO;
            }
        }];
    }
    
    return YES;
}



#pragma mark - LFLiveDelegate

/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    
    NSLog(@"%@", [NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.rtmpUrl]);
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo {
    NSLog(@"%@", debugInfo);
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
    NSLog(@"%lu", (unsigned long)errorCode);
}

@end
