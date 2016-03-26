//
//  AKTimer.m
//  TETSHMXIB
//
//  Created by Anton Korolev on 24.03.16.
//  Copyright © 2016 AntonKorolev. All rights reserved.
//

#import "AKTimer.h"

#define kDefaultTimeFormat @"HH:mm:ss"
#define kDefaultSpeedTimerNormal   0.1
#define kDefaultSpeedTimerHighUse  0.01

@interface AKTimer (){

    NSTimeInterval timeUses;
    NSDate *startCountDate;
    NSDate *pausedTime;
    NSDate *date1970;
    NSDate *timeToCountOff;
}

@property (strong) NSTimer *timer;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

- (void) setup;
- (void) update;

@end

@implementation AKTimer

# pragma mark - Init methods

-(id)initWithTimerType:(AKTimerType)type {
    self = [super init];
    
    if(self){
        self.timerType = type;
        [self setup];
    }
    return self;
}

-(void)setup{
    date1970 = [NSDate dateWithTimeIntervalSince1970:0];
    [self update];
}

#pragma mark - setter method

- (void) setCountDownTime:(NSTimeInterval)time {
    
    timeUses = (time < 0) ? 0 : time;
    timeToCountOff = [date1970 dateByAddingTimeInterval:timeUses];
    [self update];
}

-(void) addTimeCounted:(NSTimeInterval)time {
    if (_timerType == AKTimerTypeStopWatch) {
        
        NSDate *newStartDate = [startCountDate dateByAddingTimeInterval:-time];
        BOOL rangeDate = ([[NSDate date] timeIntervalSinceDate:newStartDate] <= 0);
        startCountDate = rangeDate ? [NSDate date] : newStartDate;
    }
    else
    {
        [self setCountDownTime:time + timeUses];
    }
    [self update];
}

- (NSString*)timeFormat
{
    if ([_timeFormat length] == 0 || _timeFormat == nil) {
        _timeFormat = kDefaultTimeFormat;
    }
    
    return _timeFormat;
}

-(NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale =  [NSLocale systemLocale];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        _dateFormatter.dateFormat = self.timeFormat;
    }
    return _dateFormatter;

}

#pragma mark - controll timer

-(void)start {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    BOOL timeFormatLocalSS    = ( [self.timeFormat rangeOfString:@"SS"].location != NSNotFound );
    NSTimeInterval speedTimer = timeFormatLocalSS ? kDefaultSpeedTimerHighUse : kDefaultSpeedTimerNormal;
    _timer = [NSTimer scheduledTimerWithTimeInterval:speedTimer target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    if (startCountDate == nil) {
        startCountDate = [NSDate date];
        
        if (self.timerType == AKTimerTypeStopWatch && timeUses > 0) {
            startCountDate = [startCountDate dateByAddingTimeInterval:-timeUses];
        }
    }
    
    if (pausedTime != nil) {
        NSTimeInterval countedTime = [pausedTime timeIntervalSinceDate:startCountDate];
        startCountDate = [[NSDate date] dateByAddingTimeInterval:-countedTime];
        pausedTime = nil;
    }
    
    _counting = YES;
    [_timer fire];
}

-(void)pause {
    if(_counting){
        [_timer invalidate];
        _timer = nil;
        _counting = NO;
        pausedTime = [NSDate date];
    }
}

-(void)reset {
    pausedTime = nil;
    timeUses = (self.timerType == AKTimerTypeStopWatch) ? 0 : timeUses;
    startCountDate = (_counting) ? [NSDate date] : nil;
    [self update];
}

-(void) update {
    NSTimeInterval timeRemaining = [[NSDate date] timeIntervalSinceDate:startCountDate];

    switch (_timerType) {
        
        case AKTimerTypeStopWatch:
            [self updateStopWatch:timeRemaining andTimeToShow:[NSDate date]];
            break;

        case AKTimerTypeCountDown:
            [self updateTimer:timeRemaining andTimeToShow:[NSDate date]];
            break;
            
        default:
            break;
    }
}

-(void) updateStopWatch:(NSTimeInterval) timeRemaining andTimeToShow:(NSDate *) dateRemaining {

    if (_counting) {
        dateRemaining = [date1970 dateByAddingTimeInterval:timeRemaining];
    }else{
        dateRemaining = [date1970 dateByAddingTimeInterval:(startCountDate == nil) ? 0 : timeRemaining];
    }
    
    if ([_delegate respondsToSelector:@selector(timer:countingTo:textToDisplayAtTime:timertype:)]) {
        NSString* timeText = [self.dateFormatter stringFromDate:dateRemaining];
        [_delegate timer:self countingTo:timeRemaining textToDisplayAtTime:timeText timertype:_timerType];
    }
}

-(void) updateTimer:(NSTimeInterval) timeRemaining andTimeToShow:(NSDate *) dateRemaining {

    BOOL finished = false;

    if (_counting) {

        if(timeRemaining >= timeUses){
            [self pause];
            dateRemaining = [date1970 dateByAddingTimeInterval:0];
            startCountDate = nil;
            finished = true;
        }else{
            dateRemaining = [timeToCountOff dateByAddingTimeInterval:(timeRemaining*-1)]; //added 0.999 to make it actually counting the whole first second
        }
        
    }else{
        dateRemaining = timeToCountOff;
    }
    
    if ([_delegate respondsToSelector:@selector(timer:countingTo:textToDisplayAtTime:timertype:)]) {
        NSString* timeText = [self.dateFormatter stringFromDate:dateRemaining];
        [_delegate timer:self countingTo:timeRemaining textToDisplayAtTime:timeText timertype:_timerType];

    }
    if (finished) {
        if ([_delegate respondsToSelector:@selector(timer:finshedTimer:)]) {
            [_delegate timer:self finshedTimer:timeUses];
            [self reset];
        }
    }
}


@end
