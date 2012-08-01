//
//  AgenceModalView.h
//  Affinity
//
//  Created by Christophe Bergé on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgenceModalViewDelegate;

@interface AgenceModalView : UIViewController {
    //UINavigationBar *navBar;
    NSNumber *textIndex;
    
}

@property (nonatomic, assign) id <AgenceModalViewDelegate> delegate;

@end

@protocol AgenceModalViewDelegate
- (void)agenceModalViewDidFinish:(AgenceModalView *)controller;
@end
