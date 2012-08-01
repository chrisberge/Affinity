//
//  PresentationAkios.h
//  Affinity
//
//  Created by Christophe Bergé on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentationAkiosDelegate;

@interface PresentationAkios : UIViewController

@property (nonatomic, assign) id <PresentationAkiosDelegate> delegate;

@end

@protocol PresentationAkiosDelegate
- (void)presentationAkiosDidFinish:(PresentationAkios *)controller;

@end
