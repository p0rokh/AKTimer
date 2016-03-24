//
//  AKTimer.h
//  TETSHMXIB
//
//  Created by Anton Korolev on 24.03.16.
//  Copyright © 2016 AntonKorolev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AKTimerTypeStopWatch,
    AKTimerTypeTimer,
} AKTimerType;


/*********************
    Methods delegate 
**********************/

@class AKTimer;
@protocol AKTimerLabelDelegate <NSObject>

@optional
-(void) timer:(AKTimer *)timer countingTo:(NSTimeInterval)time textToDisplayAtTime:(NSString* )timeText timertype:(AKTimerType)timerType;
-(void) timer:(AKTimer *)timer finshedTimer:(NSTimeInterval)time;

@end


/*****************
    AKTIMER CLASS
 *****************/
@interface AKTimer : NSObject

@property (nonatomic,weak) id<AKTimerLabelDelegate> delegate;

@property (nonatomic,copy) NSString *timeFormat;

@property (assign) AKTimerType timerType;

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
