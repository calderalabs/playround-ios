//
//  PRActivityTableViewCell.h
//  Playround
//
//  Created by Eugenio Depalo on 7/5/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

@interface PRActivityTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *status;

- (void)stopAnimating;
- (void)startAnimating;

@end
