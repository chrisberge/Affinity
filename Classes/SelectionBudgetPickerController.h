//
//  SelectionBudgetPickerController.h
//  Affinity
//
//  Created by Christophe Bergé on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Intervalle;

@interface SelectionBudgetPickerController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate> {
	Intervalle *intervalle;
    UITextField *textMin;
    UITextField *textMax;
    UILabel *labelMin;
    UILabel *labelMax;
    NSString *prix_mini;
    NSString *prix_maxi;
    UIPickerView *myPickerView;
    NSArray *prix_min;
    NSArray *prix_max;
    
}

@property (retain,nonatomic) Intervalle *intervalle;
@property (retain,nonatomic) UITextField *textMin;
@property (retain,nonatomic) UITextField *textMax;
@property (retain,nonatomic) UILabel *labelMin;
@property (retain,nonatomic) UILabel *labelMax;

@end
