//
//  PGAudioManager.m
//  NoTiToBroadNSE
//
//  Created by WGPawn on 2021/11/16.
//

#import "PGAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>


@interface PGAudioManager ()
{
    AVSpeechSynthesizer *synthesizer;
}
 
  

@end

@implementation PGAudioManager


+ (instancetype)sharedInstance{
    static PGAudioManager *_instance = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[PGAudioManager alloc] init] ;
    }) ;
    return _instance ;
}

/// 设置存储过程 文件名称  this local mp3 file name is need for UNNotificationSound  UNNotificationSoundName
-(NSString*)getViceNameWith:(NSData*) audioData  audioDuration:(AudioDurationBlock) audioDurationBlock
{

        NSString *soundsDirectory = [self getAudioStorageDirectoryPath];
        
        int a = arc4random() % 100000;

        NSString * voiceName = [NSString stringWithFormat:@"%d.mp3",a];
        
        NSString *resultFilePath = [soundsDirectory stringByAppendingPathComponent:voiceName];
        
        NSLog(@"resultFilePath === %@",resultFilePath);
        
       BOOL suc =  [audioData writeToFile:resultFilePath atomically:YES];
    
    if (suc) {
        
        NSURL * audioFileURL = [[NSURL fileURLWithPath:soundsDirectory] URLByAppendingPathComponent:voiceName];

        AVURLAsset *audioAsset=[AVURLAsset URLAssetWithURL:audioFileURL options:nil];
        CMTime audioDuration=audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        audioDurationBlock(audioDurationSeconds);
    }
        NSLog(@"voiceName === %@",voiceName);
    
    return  voiceName;   
}

/// 获取音频存储路径 save online mp3 file to AppGroup/Library/Sound
- (NSString *)getAudioStorageDirectoryPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"your groupid"];
    NSString *outPutFilePath = groupURL.path;
    NSLog(@"outPutFilePath === %@",outPutFilePath);
    NSString *libraryName = [outPutFilePath stringByAppendingPathComponent:@"Library"];
    BOOL isLibraryDir;
    if (![fileManager fileExistsAtPath:libraryName isDirectory:&isLibraryDir]) {
        [fileManager createDirectoryAtPath:libraryName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL isSoundsDir;
    NSString *soundsName = [libraryName stringByAppendingPathComponent:@"Sounds"];
    if (![fileManager fileExistsAtPath:soundsName isDirectory:&isSoundsDir]) {
        [fileManager createDirectoryAtPath:soundsName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return soundsName;
}


#pragma mark iOS12.1以下 播放语音
//语音播报红包消息
- (void)speechWalllentMessage:(NSString *)numStr {
   
   //播放语音
   // 合成器 控制播放，暂停
   AVSpeechSynthesizer *_synthesizer;
   // 实例化说话的语言，说中文、英文
   AVSpeechSynthesisVoice *_voice;
   _voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
   // 要朗诵，需要一个语音合成器
   _synthesizer = [[AVSpeechSynthesizer alloc] init];
   AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"支付爸爸付为您收款%@元",numStr]];
   //指定语音，和朗诵速度
   utterance.voice = _voice;
//    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
   utterance.rate = 0.55;
   utterance.pitchMultiplier = 1.0f;  //改变音调
//    utterance.volume = 1;
   //启动
   [_synthesizer speakUtterance:utterance];
   
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"开始");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.finshBlock();
    NSLog(@"结束");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{

}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{

}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{

}


@end
