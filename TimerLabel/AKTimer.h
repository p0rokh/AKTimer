//
//  AKTimer.h
//  TETSHMXIB
//
//  Created by Anton Korolev on 24.03.16.
//  Copyright © 2016 AntonKorolev. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************
    Timer type
    For the countdown timer, you must specify the runtime.
 **********************/

typedef enum {
    AKTimerTypeStopWatch,
    AKTimerTypeCountDown,
} AKTimerType;


/*********************
    Methods delegate 
**********************/

@class AKTimer;
@protocol AKTimerLabelDelegate <NSObject>

@optional

/* If you need to keep track of the timer, implement this method delegate. */
-(void) timer:(AKTimer *)timer countingTo:(NSTimeInterval)time textToDisplayAtTime:(NSString* )timeText timertype:(AKTimerType)timerType;

/* Use this method delegate to implement the logic of your application, if you use a timer with a countdown type. */
-(void) timer:(AKTimer *)timer finshedTimer:(NSTimeInterval)time;

@end


/*****************
    AKTIMER CLASS
 *****************/
@interface AKTimer : NSObject

@property (nonatomic,weak) id<AKTimerLabelDelegate> delegate;

/*Format text output using DateFormat. The default value is set to "HH: bb: SS".
 Options for viewing formats can be here "http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/"*/
@property (nonatomic,copy) NSString *timeFormat;

@property (assign) AKTimerType timerType;

/* Timer status */
@property (assign,readonly) BOOL counting;

/* Init methods */
- (id) initWithTimerType:(AKTimerType) type;


/*  Methods to control the Timer  */
- (void) start;
- (void) pause;
- (void) reset;

/* Setter method */
- (void) setCountDownTime:(NSTimeInterval)time;
- (void) addTimeCounted:(NSTimeInterval)time;

@end
