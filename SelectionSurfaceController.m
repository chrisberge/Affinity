//
//  SelectionSurfaceController.m
//  
//
//  Created by Christophe Bergé on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectionSurfaceController.h"
#import "Intervalle.h"

@implementation SelectionSurfaceController

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
    
    UIViewController *tempView = [self.navigationController.viewControllers objectAtIndex:0];
    
    if (tempView.title == @"Accueil") {
        postString = @"Multi";
    }
    
    if (tempView.title == @"Favoris") {
        postString = @"Favoris";
    }
    
    NSString *name = [NSString stringWithFormat:@"getCriteres%@",postString];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object: nil];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    /*--- TEXT VIEWS ---*/
    textMin = [[UITextField alloc] init];
    textMin.font = [UIFont fontWithName:@"Arial" size:20.0f];
    [textMin setFrame:CGRectMake(8, 50, 150, 30)];
    textMin.textAlignment = UITextAlignmentRight;
    textMin.borderStyle = UITextBorderStyleRoundedRect;
    textMin.keyboardType = UIKeyboardTypeNumberPad;
    textMin.delegate = self;
    textMin.text = surface_mini;
    [self.view addSubview:textMin];
    
    textMax = [[UITextField alloc] init];
    textMax.font = [UIFont fontWithName:@"Arial" size:20.0f];
    [textMax setFrame:CGRectMake(8, 130, 150, 30)];
    textMax.textAlignment = UITextAlignmentRight;
    textMax.borderStyle = UITextBorderStyleRoundedRect;
    textMax.keyboardType = UIKeyboardTypeNumberPad;
    textMax.delegate = self;
    textMax.text = surface_maxi;
    [self.view addSubview:textMax];
    /*--- TEXT VIEWS ---*/
    
    /*--- LABELS ---*/
    labelMin = [[UILabel alloc] initWithFrame:CGRectMake(8, 20, 150, 30)];
    labelMax = [[UILabel alloc] initWithFrame:CGRectMake(8, 100, 150, 30)];
    
    labelMin.textAlignment = UITextAlignmentCenter;
    labelMax.textAlignment = UITextAlignmentCenter;
    
    [labelMin setText:@"Surface minimum"];
    [labelMax setText:@"Surface maximum"];
    
    labelMin.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    labelMax.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [self.view addSubview:labelMin];
    [self.view addSubview:labelMax];
    /*--- LABELS ---*/
    
    //BOUTON RETOUR
    UIButton *boutonRetour = [UIButton buttonWithType:UIButtonTypeCustom];
    boutonRetour.showsTouchWhenHighlighted = NO;
    boutonRetour.tag = 3;
    
    [boutonRetour setFrame:CGRectMake(250,100,50,30)];
    [boutonRetour addTarget:self action:@selector(buttonPushed:) 
           forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"bouton-retour.png"];
    [boutonRetour setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:boutonRetour];
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
        SurfaceMax = [SurfaceMax stringByReplacingOccurrencesOfString:@" " withString:@""];
        
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
            intervalle.min = 0;
            intervalle.max = SurfaceMaxInt;
        }
        
        if (SurfaceMaxInt == 0 && SurfaceMinInt == 0) {
            intervalle.min = 0;
            intervalle.max = 0;
        }
        NSString *name = [NSString stringWithFormat:@"surfaceSelected%@",postString];
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:intervalle];
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [textMin release];
    [textMax release];
    [labelMin release];
    [labelMax release];
	[self viewDidUnload];
    [super dealloc];
}


@end
