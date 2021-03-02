//
//  NSObject+DeLocalizedNumberStrings.h
//  mWallet
//
//  Created by Ehab Asaad Hanna on 11/7/13.
//  Copyright (c) 2013 Ehab Asaad Hanna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DeLocalizedNumberStrings)
- (NSString *) delocalize;
- (NSString *) relocalize;
@end

