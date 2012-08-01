//
//  SelectionSurfaceController.h
//  
//
//  Created by Christophe Bergé on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Intervalle;

@interface SelectionSurfaceController : UIViewController <UITextFieldDelegate> {
	Intervalle *intervalle;
    UITextField *textMin;
    UITextField *textMax;
    UILabel *labelMin;
    UILabel *labelMax;
    NSString *surface_mini;
    NSString *surface_maxi;
    NSString *postString;
    
}

@property (retain,nonatomic) Intervalle *intervalle;
@property (retain,nonatomic) UITextField *textMin;
@property (retain,nonatomic) UITextField *textMax;
@property (retain,nonatomic) UILabel *labelMin;
@property (retain,nonatomic) UILabel *labelMax;

@end
