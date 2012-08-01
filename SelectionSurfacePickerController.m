//
//  SelectionSurfacePickerController.m
//  Affinity
//
//  Created by Christophe Bergé on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectionSurfacePickerController.h"
#import "Intervalle.h"

@implementation SelectionSurfacePickerController

@synthesize intervalle, textMin, textMax, labelMin, labelMax;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
	intervalle = [[Intervalle alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(setCriteres:) name:@"setCriteres" object: nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getCriteres" object: nil];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    /*--- DATA PICKERVIEW ---*/
    surface_min = [[NSArray alloc] initWithObjects:@"0",
                @"10",
                @"20",
                @"30",
                @"40",
                @"50",
                @"60",
                @"70",
                @"80",
                @"90",
                @"100",
                @"200",
                @"300",
                nil];
    
    surface_max = [[NSArray alloc] initWithObjects:@"9",
                @"19",
                @"29",
                @"39",
                @"49",
                @"59",
                @"69",
                @"79",
                @"89",
                @"99",
                @"199",
                @"299",
                @"399",
                nil];
    /*--- DATA PICKERVIEW ---*/
    
    /*--- IMAGE TABLEAU ---*/
    UIImageView *imgTableau = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableau.png"]];
    [imgTableau setFrame:CGRectMake(20, 60, 280, 100)];
    [self.view addSubview:imgTableau];
    [imgTableau release];
    /*--- IMAGE TABLEAU ---*/
    
    /*--- IMAGE PRIX MIN MAX ---*/
    UIImageView *surfaceMinMax = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"surface-min-max.png"]];
    [surfaceMinMax setFrame:CGRectMake(0, 190, 320, 53)];
    [self.view addSubview:surfaceMinMax];
    [surfaceMinMax release];
    /*--- IMAGE PRIX MIN MAX ---*/
    
    /*--- TEXT VIEWS ---*/
    textMin = [[UITextField alloc] init];
    //textMin.font = [UIFont fontWithName:@"Arial" size:20.0f];
    [textMin setFrame:CGRectMake(120, 75, 170, 30)];
    textMin.textAlignment = UITextAlignmentLeft;
    textMin.borderStyle = UITextBorderStyleNone;
    textMin.userInteractionEnabled = NO;
    //textMin.keyboardType = UIKeyboardTypeNumberPad;
    textMin.delegate = self;
    textMin.text = surface_mini;
    [self.view addSubview:textMin];
    
    textMax = [[UITextField alloc] init];
    //textMax.font = [UIFont fontWithName:@"Arial" size:20.0f];
    [textMax setFrame:CGRectMake(120, 125, 170, 30)];
    textMax.textAlignment = UITextAlignmentLeft;
    textMax.borderStyle = UITextBorderStyleNone;
    textMax.userInteractionEnabled = NO;
    //textMax.keyboardType = UIKeyboardTypeNumberPad;
    textMax.delegate = self;
    textMax.text = surface_maxi;
    [self.view addSubview:textMax];
    /*--- TEXT VIEWS ---*/
    
    /*--- LABELS ---*/
    labelMin = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, 30, 30)];
    labelMax = [[UILabel alloc] initWithFrame:CGRectMake(70, 120, 20, 30)];
    
    labelMin.textAlignment = UITextAlignmentCenter;
    labelMax.textAlignment = UITextAlignmentCenter;
    
    [labelMin setText:@"De:"];
    [labelMax setText:@"à:"];
    
    //labelMin.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    //labelMax.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [self.view addSubview:labelMin];
    [self.view addSubview:labelMax];
    /*--- LABELS ---*/
    
    //BOUTON RETOUR
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 3;
    
    [boutonRetour setFrame:CGRectMake(250,20,50,30)];
    [boutonRetour addTarget:self action:@selector(buttonPushed:) 
           forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"bouton-retour.png"];
    [boutonRetour setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRetour];
    
    /*--- PICKERVIEW ---*/
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 232, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:myPickerView];
    /*--- PICKERVIEW ---*/
}

- (void) buttonPushed:(id)sender
{
	UIButton *button = sender;
    
	switch (button.tag) {
        case 3:
            [self.navigationController popViewControllerAnimated:YES];
            break;
		default:
			break;
	}
}

- (void) setCriteres:(NSNotification *)notify
{
    NSLog(@"criteres setCriteres %@",[notify object]);
    NSMutableDictionary *criteres = [notify object];
    
    surface_mini = [criteres valueForKey:@"surface_mini"];
    surface_maxi = [criteres valueForKey:@"surface_maxi"];
    
    NSNumber *formattedResult;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:@" "];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    formattedResult = [NSNumber numberWithInt:[surface_mini intValue]];
    
    surface_mini = [formatter stringForObjectValue:formattedResult];
    
    formattedResult = [NSNumber numberWithInt:[surface_maxi intValue]];
    
    surface_maxi = [formatter stringForObjectValue:formattedResult];
    
    [formatter release];
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    
    if ([newString length] <= 10) {
        
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[newString intValue]];
        
        string = [formatter stringForObjectValue:formattedResult];
        string = [string stringByAppendingString:@" m²"];
        [textField setText:string];
        [formatter release];
    }
    //Returning yes allows the entered chars to be processed
    return NO;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.intervalle = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([labelMin.text length] != 0 || [labelMax.text length] != 0) {
        
        NSString *SurfaceMin = [textMin.text substringToIndex:[textMin.text length]];
        NSString *SurfaceMax = [textMax.text substringToIndex:[textMax.text length]];
        
        SurfaceMin = [SurfaceMin stringByReplacingOccurrencesOfString:@" " withString:@""];
        SurfaceMin = [SurfaceMin stringByReplacingOccurrencesOfString:@"m²" withString:@""];
        
        SurfaceMax = [SurfaceMax stringByReplacingOccurrencesOfString:@" " withString:@""];
        SurfaceMax = [SurfaceMax stringByReplacingOccurrencesOfString:@"m²" withString:@""];
        
        int SurfaceMinInt = [SurfaceMin intValue];
        int SurfaceMaxInt = [SurfaceMax intValue];
        
        if (SurfaceMinInt != 0 && SurfaceMaxInt != 0) {
            if (SurfaceMinInt < SurfaceMaxInt) {
                intervalle.min = SurfaceMinInt;
                intervalle.max = SurfaceMaxInt;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur de saisie"
                                                                message:@"La surface maximum est inférieure à la minimum."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
        
        if (SurfaceMinInt != 0 && SurfaceMaxInt == 0) {
            intervalle.min = SurfaceMinInt;
        }
        
        if (SurfaceMaxInt != 0 && SurfaceMinInt == 0) {
            intervalle.max = SurfaceMaxInt;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"surfaceSelected" object:intervalle];
    }
    [super viewWillDisappear:animated];
}

/*--- DELEGUE PICKERVIEW ---*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		return [surface_min count];
	}
	else {
		return [surface_max count];
	}
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0) {
        
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[surface_min objectAtIndex:row] intValue]];
        
        NSString *stringSurfaceMin = [formatter stringForObjectValue:formattedResult];
        [formatter release];
        
		return stringSurfaceMin;
	}
	else {
        NSNumber *formattedResult;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSeparator:@" "];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        formattedResult = [NSNumber numberWithInt:[[surface_max objectAtIndex:row] intValue]];
        
        NSString *stringSurfaceMax = [formatter stringForObjectValue:formattedResult];
        [formatter release];
        
		return stringSurfaceMax;
	}
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (component == 0) {
        [self  textField:textMin shouldChangeCharactersInRange:NSMakeRange(0, [textMin.text length]) replacementString:[surface_min objectAtIndex:row]];
        if ([textMin.text intValue] > [textMax.text intValue]) {
            [pickerView selectRow:row inComponent:1 animated:YES];
            [self  textField:textMax shouldChangeCharactersInRange:NSMakeRange(0, [textMax.text length]) replacementString:[surface_max objectAtIndex:row]];
        }
        //[pickerView reloadComponent:1];
	}
	else {
        [self  textField:textMax shouldChangeCharactersInRange:NSMakeRange(0, [textMax.text length]) replacementString:[surface_max objectAtIndex:row]];
        if ([textMin.text intValue] > [textMax.text intValue]) {
            [pickerView selectRow:row inComponent:0 animated:YES];
            [self  textField:textMin shouldChangeCharactersInRange:NSMakeRange(0, [textMin.text length]) replacementString:[surface_min objectAtIndex:row]];
        }
	}
}
/*--- DELEGUE PICKERVIEW ---*/

- (void)dealloc {
    [textMin release];
    [textMax release];
    [labelMin release];
    [labelMax release];
    [surface_max release];
    [surface_min release];
	[self viewDidUnload];
    [super dealloc];
}

@end
