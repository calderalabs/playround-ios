//
//  PRActivityTableViewCell.m
//  Playround
//
//  Created by Eugenio Depalo on 7/5/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRActivityTableViewCell.h"

@interface PRActivityTableViewCell ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@end

@implementation PRActivityTableViewCell

- (void)setStatus:(NSString *)status {
    if(![status isEqualToString:self.statusLabel.text]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.statusLabel.alpha = 0.0f;
            self.statusLabel.text = status;
            self.statusLabel.alpha = 1.0f;
        }];
    }
}

- (NSString *)status {
    return self.statusLabel.text;
}

- (void)startAnimating {
    [self.activityIndicatorView startAnimating];
    [self setNeedsLayout];
}

- (void)stopAnimating {
    [self.activityIndicatorView stopAnimating];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    static const CGFloat kPadding = 10;
    CGFloat labelOffset = 10;
    
    if(self.activityIndicatorView.isAnimating)
        labelOffset = self.activityIndicatorView.frame.origin.x + self.activityIndicatorView.frame.size.width + kPadding;
    
    self.statusLabel.frame = CGRectMake(labelOffset,
                                        kPadding,
                                        self.statusLabel.frame.size.width,
                                        self.statusLabel.frame.size.height);
}

@end
