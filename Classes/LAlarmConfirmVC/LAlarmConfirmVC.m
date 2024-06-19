//
//  addAlarmVC.m
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LAlarmConfirmVC.h"
#import "LAlarmOnOffVC.h"

@import UserNotifications;


@interface LAlarmConfirmVC ()


@end

@implementation LAlarmConfirmVC

#pragma mark - Overrides


- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Larm via On/Off" message:@"Tryck på telefonens On/Off-knapp för att aktivera larmet. Larmet avvaktar 10s innan aktivering. Om du ångrar dig, återstarta appen, svep till höger och ange din behörighetskod.När funktionen används kommer appen förhindra att telefonens skärmlås aktiveras. Detta drar extra mycket batteri.Observera att appen MÅSTE vara i fokus hela tiden. Om du stänger av appen eller byter till annan app kommer larm via On/Off-knappen autoamatiskt att inaktiveras.Svep till höger och ange din behörighetskod för att avsluta larmet." preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //button click event
        LAlarmOnOffVC* vc = [[LAlarmOnOffVC alloc] initWithNibName:@"LAlarmOnOffVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];

                        }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //button click event
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];

//        [self.navigationController popViewControllerAnimated:YES];
                        }];

    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


@end
