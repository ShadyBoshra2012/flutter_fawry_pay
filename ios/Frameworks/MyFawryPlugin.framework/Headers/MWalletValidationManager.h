//
//  MWalletValidationManager.h
//  MyFawry
//
//  Created by Hany Nady on 12/7/15.
//  Copyright © 2015 Ehab Asaad Hanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+DeLocalizedNumberStrings.h"

@interface MWalletValidationManager : NSObject


+ (MWalletValidationManager *)sharedInstance ;


//**Validate that password lenght is between 6 to 20 digit*/
- (BOOL)passwordLengthValid:(NSString *)password;

- (BOOL)stringContainsUpperCaseLetter:(NSString *)str;

- (BOOL)stringContainsLowerCaseLetter:(NSString *)str;

//**Validate that pin lenght/
- (BOOL)pinLengthValid:(NSString *)pin;
- (BOOL)hasPinSequence:(NSString*)value;
- (BOOL)hasPinNoRepeatedChars:(NSString *)string;

//**Check that string contains (._@%$!&-) */
- (BOOL)stringContainsSpecialCharacter:(NSString *)str;

- (BOOL)stringContainsNumber:(NSString *)str;

- (BOOL)isStringNumeric:(NSString *)testString;

- (BOOL)phoneNumberHasCountryCode:(NSString *)phoneNumber;

- (NSString *)phoneNumberWithCountryCode:(NSString *)phoneNumber;

- (NSString *) removeCountryCodeFromNumber:(NSString *) phoneNumber;

- (BOOL)isEmailAddressValid: (NSString *)email;

- (BOOL) isProperEgyptianNumber:(NSString *) rawPhoneNumber;
- (BOOL)isCardNumberVisa: (NSString *)ccNum;
- (BOOL)isCardNumberMasterCard: (NSString *)ccNum;
- (BOOL) isCreditCardSubTypeValid : (NSString *)ccNum;

- (BOOL) isCardExpOfValidLength: (NSString *)text;
-(BOOL)isCardDateExpired:(NSString*)text;
- (BOOL) isCardNumOfValidLength :(NSString *)text;
- (BOOL) isCVCOfValidLength: (NSString *)text;
- (BOOL) isCIFValidLength: (NSString *)text;
- (NSString *) removeWhiteSpacesFromString:(NSString *) string;
- (BOOL) isSplit:(NSString*)str;

- (BOOL)isStringContainArabicCharacters:(NSString*)str;
- (NSString *)encodeWithUTF8:(NSString *)input;

@end
