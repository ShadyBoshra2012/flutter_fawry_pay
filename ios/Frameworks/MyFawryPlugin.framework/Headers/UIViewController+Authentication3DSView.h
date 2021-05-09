//
//  UIViewController+Authentication3DSView.h
//  MyFawry
//
//  Created by Ehab Asaad Hanna on 5/4/16.
//  Copyright © 2016 Ehab Asaad Hanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authentication3DSView.h"

@interface UIViewController (Authentication3DSView)

- (void) get3DsAuthenticationFromURL:(NSString *) url withParams:(NSDictionary *) params;

@end
