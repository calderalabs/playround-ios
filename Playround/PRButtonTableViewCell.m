//
//  PRButtonTableViewCell.m
//  Playround
//
//  Created by Eugenio Depalo on 6/27/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRButtonTableViewCell.h"

@interface PRButtonTableViewCell ()

- (void)buttonTouchUpInside:(UIButton *)button;

@end

@implementation PRButtonTableViewCell

- (void)awakeFromNib {
    [self.button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTouchUpInside:(UIButton *)button {
    if([self.delegate respondsToSelector:@selector(didTapButtonTableViewCell:)])
        [self.delegate didTapButtonTableViewCell:self];
}

@end
