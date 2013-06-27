//
//  PRButtonTableViewCell.h
//  Playround
//
//  Created by Eugenio Depalo on 6/27/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

@class PRButtonTableViewCell;

@protocol PRButtonTableViewCellDelegate <NSObject>

@optional

- (void)didTapButtonTableViewCell:(PRButtonTableViewCell *)cell;

@end

@interface PRButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, weak) id<PRButtonTableViewCellDelegate> delegate;

@end

