//
//  SelectionSurfacePickerController.h
//  Affinity
//
//  Created by Christophe Bergé on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Intervalle;

@interface SelectionSurfacePickerController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate> {
	Intervalle *intervalle;
    UITextField *textMin;
    UITextField *textMax;
    UILabel *labelMin;
    UILabel *labelMax;
    NSString *surface_mini;
    NSString *surface_maxi;
    UIPickerView *myPickerView;
    NSArray *surface_min;
    NSArray *surface_max;
    
}

@property (retain,nonatomic) Intervalle *intervalle;
@property (retain,nonatomic) UITextField *textMin;
@property (retain,nonatomic) UITextField *textMax;
@property (retain,nonatomic) UILabel *labelMin;
@property (retain,nonatomic) UILabel *labelMax;

@end
