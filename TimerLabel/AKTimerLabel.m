//
//  AKTimerLabel.m
//  TETSHMXIB
//
//  Created by Anton Korolev on 24.03.16.
//  Copyright © 2016 AntonKorolev. All rights reserved.
//

#import "AKTimerLabel.h"

IB_DESIGNABLE
@interface AKTimerLabel ()

@property (nonatomic) IBInspectable UIColor* fillColor;
@property (nonatomic) IBInspectable NSInteger lineWidth;

@end

@implementation AKTimerLabel

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = self.bounds;
    CGContextSetLineWidth(context, _lineWidth);
    CGRectInset(myFrame, 5, 5);
    [_fillColor set];
    UIRectFrame(myFrame);
    
    [super drawTextInRect:rect];
}

@end
