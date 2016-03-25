//
//  AKExempleController.m
//  TETSHMXIB
//
//  Created by Anton Korolev on 24.03.16.
//  Copyright © 2016 AntonKorolev. All rights reserved.
//

#import "AKExempleController.h"
#import "AKTimer.h"
#import "AKAdditionButton.h"

#define kAdditionGroupTimer_1 @"CDTimer"
#define kAdditionGroupTimer_2 @"SWTimer"

@interface AKExempleController () <AKTimerLabelDelegate>


@property (strong) AKTimer* timer_1;
@property (strong) AKTimer* timer_2;


@property (weak, nonatomic) IBOutlet UIButton *startAndPauseButton_1;
@property (weak, nonatomic) IBOutlet UIButton *resetButton_1;

@property (weak, nonatomic) IBOutlet UIButton *startAndPauseButton_2;
@property (weak, nonatomic) IBOutlet UIButton *resetButton_2;

@end

@implementation AKExempleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timer_1 = [[AKTimer alloc] initWithTimerType:AKTimerTypeCountDown];
    _timer_1.delegate = self;
    [_timer_1 setCountDownTime:33];

    _timer_2 = [[AKTimer alloc] initWithTimerType:AKTimerTypeStopWatch];
    _timer_2.delegate = self;
    
}

-(void)timer:(AKTimer *)timer countingTo:(NSTimeInterval)time textToDisplayAtTime:(NSString *)timeText timertype:(AKTimerType)timerType {
    if (timer == _timer_1) {
        self.timeLabel_1.text = timeText;
    }
    
    if (timer == _timer_2) {
        self.timeLabel_2.text = timeText;
    }
}

-(void)timer:(AKTimer *)timer finshedTimer:(NSTimeInterval)time {
    if (timer == _timer_1) {
        [_startAndPauseButton_1 setTitle:@"start" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)startAndPauseTimer:(UIButton *)sender {
    AKTimer *timer;
    if (sender == _startAndPauseButton_1) {
        timer = _timer_1;
    }
    
    if (sender == _startAndPauseButton_2) {
        timer = _timer_2;
    }
    
    [self updateButton:sender andTimer:timer];

}

- (void) updateButton:(UIButton *) sender andTimer:(AKTimer *)timer {
    if([timer counting]){
        [timer pause];
        [sender setTitle:@"resume" forState:UIControlStateNormal];
    }else{
        [timer start];
        [sender setTitle:@"pause" forState:UIControlStateNormal];
    }
}

- (IBAction)resetTimer:(UIButton *)sender {
    if (sender == _resetButton_1) {
        [self resetTimer:_timer_1 andUpdateButton:_startAndPauseButton_1];
    }
    
    if (sender == _resetButton_2) {
        [self resetTimer:_timer_2 andUpdateButton:_startAndPauseButton_2];
    }
}

- (void) resetTimer:(AKTimer *)timer andUpdateButton:(UIButton *) sender {
    [timer reset];
    
    if(![timer counting]){
        [sender setTitle:@"start" forState:UIControlStateNormal];
    }
}

- (IBAction)addAdditionalTime:(AKAdditionButton *)sender {
    if ([sender.identifier isEqualToString:kAdditionGroupTimer_1]) {
        [_timer_1 addTimeCounted:sender.tag];
    }
    
    if ([sender.identifier isEqualToString:kAdditionGroupTimer_2]) {
        [_timer_2 addTimeCounted:sender.tag];
    }
    
}

@end
