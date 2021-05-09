//
//  ActionSheetPickerView.h
//  MyFawry
//
//  Created by Ehab Asaad Hanna on 3/1/16.
//  Copyright © 2016 Ehab Asaad Hanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionSheetPickerViewItem <NSObject>

- (UIImage *) provideImage;
- (NSString *) provideTitle;
- (UIImage *) selectedImage;

@end

@class ActionSheetPickerView;
@protocol ActionSheetPickerViewDelegate <NSObject>

- (void) actionSheetPickerView:(ActionSheetPickerView *) actionSheet didSelectOption:(id<ActionSheetPickerViewItem>) item atIndexPath:(NSIndexPath *) path;
- (void) actionSheetPickerViewDidCancel:(ActionSheetPickerView *)actionSheet;

@end

@interface ActionSheetPickerView : UIView

@property (weak, nonatomic) IBOutlet UIView *actionsheetContainer;
@property (weak, nonatomic) IBOutlet UILabel *actionsheetTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *actionsheetTableView;
@property (weak, nonatomic) IBOutlet UILabel *noItemsLabel;
@property (assign, nonatomic) id<ActionSheetPickerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionsheetHeightConstraint;

+ (instancetype)createActionSheetWithTitle:(NSString *) title noItemsTitle:(NSString *) noItemsTitle anditems:(NSArray<id<ActionSheetPickerViewItem>> *) someItems;

+ (instancetype)createActionSheetWithTitle:(NSString *) title noItemsTitle:(NSString *) noItemsTitle anditems:(NSArray<id<ActionSheetPickerViewItem>> *) someItems selectedIndex:(NSInteger)index;

- (void) showInView:(UIView *) parentView;
- (void) dismissView;

+ (NSArray *) generateDummyItems;
@end
