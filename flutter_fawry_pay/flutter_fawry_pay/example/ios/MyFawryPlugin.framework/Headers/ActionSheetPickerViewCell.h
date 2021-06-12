//
//  ActionSheetPickerViewCellTableViewCell.h
//  MyFawry
//
//  Created by Ehab Asaad Hanna on 3/1/16.
//  Copyright © 2016 Ehab Asaad Hanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionSheetPickerViewCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
