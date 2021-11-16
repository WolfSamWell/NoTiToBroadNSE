//
//  PGAudioManager.h
//  NoTiToBroadNSE
//
//  Created by WGPawn on 2021/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



/// 后台播放处理类
@interface PGAudioManager : NSObject

typedef void(^AudioDurationBlock)(float dur);

typedef void(^PlayVoiceBlock)(void);

/// AVSpeechSynthesisVoice 播放完毕之后的回调block
@property (nonatomic, copy)PlayVoiceBlock finshBlock;

/*
 
 使用https://www.coder.work/text2audio转化文字到mp3，使用https://codebeautify.org/mp3-to-base64-converter 转化base64.拿该base64的data测试下面的方法。
 **/
+ (instancetype)sharedInstance;

/// base64 to mp3
-(NSString*)getViceNameWith:(NSData*) audioData  audioDuration:(AudioDurationBlock) audioDurationBlock;
/// 12.1 以下使用播报
- (void)speechWalllentMessage:(NSString *)numStr;

@end

NS_ASSUME_NONNULL_END
