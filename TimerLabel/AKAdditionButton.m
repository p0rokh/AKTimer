//
//  AKAdditionButton.m
//  TETSHMXIB
//
//  Created by Anton Korolev on 25.03.16.
//  Copyright © 2016 AntonKorolev. All rights reserved.
//

#import "AKAdditionButton.h"

IB_DESIGNABLE
@interface AKAdditionButton ()

@property (nonatomic) IBInspectable NSString* identifierTimer;

@end

@implementation AKAdditionButton

-(NSString *)identifier{
    if (_identifier == nil) {
        _identifier = self.identifierTimer;
    }
    return _identifier;
}

@end
