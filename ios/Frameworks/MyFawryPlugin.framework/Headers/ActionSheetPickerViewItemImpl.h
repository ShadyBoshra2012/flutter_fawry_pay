//
//  ActionSheetPickerViewItemImpl.h
//  MyFawry
//
//  Created by Ehab Asaad Hanna on 7/27/16.
//  Copyright © 2016 Ehab Asaad Hanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionSheetPickerView.h"

@interface ActionSheetPickerViewItemImpl : NSObject<ActionSheetPickerViewItem>

@property (nonatomic, strong) id originalItem;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectionImage;

@end
