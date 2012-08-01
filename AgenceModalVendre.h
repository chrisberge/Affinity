//
//  AgenceModalVendre.h
//  Affinity
//
//  Created by Christophe Bergé on 14/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgenceModalVendreDelegate;

@interface AgenceModalVendre : UIViewController<UITextFieldDelegate>{
    NSString *nom;
    NSString *prenom;
    NSString *telephone;
    NSString *email;
    NSString *type_bien;
    NSString *surface;
    NSString *nb_pieces;
    NSString *prix;
    NSString *adresse;
    NSString *code_postal;
    NSString *ville;
    UITextField *nomTF;
    UITextField *prenomTF;
    UITextField *telephoneTF;
    UITextField *emailTF;
    UITextField *type_bienTF;
    UITextField *surfaceTF;
    UITextField *nb_piecesTF;
    UITextField *prixTF;
    UITextField *adresseTF;
    UITextField *code_postalTF;
    UITextField *villeTF;
}

@property (nonatomic, assign) id <AgenceModalVendreDelegate> delegate;

@end

@protocol AgenceModalVendreDelegate
- (void)agenceModalVendreDidFinish:(AgenceModalVendre *)controller;
@end
