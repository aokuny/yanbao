//
//  CLTableLabelsMatrix.m
//

#import "TableLabelsMatrix.h"

@implementation TableLabelsMatrix


- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns{
    self = [super initWithFrame:frame];
    if (self) {
        numRows = 0;
        self->columnsWidths = columns;
		self->dy = 0;
		self->numRows = 0;
        self.rowHeight = 30;
    }
    return self;
}


- (void)addRecord: (NSArray*)record {
    if(record.count != self->columnsWidths.count){
        NSLog(@"!!! Number of items does not match number of columns. !!!");
        return;
    }
//    uint rowHeight = 30;
	uint dx = 0;
	
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    
	//CREATE THE ITEMS/COLUMNS OF THE ROW
    for(uint i=0; i<record.count; i++){
        float colWidth = [[self->columnsWidths objectAtIndex:i] floatValue];	//colwidth as given at setup
        CGRect rect = CGRectMake(dx, dy, colWidth, _rowHeight);
		
		//ADJUST X FOR BORDER OVERLAPPING BETWEEN COLUMNS
		if(i>0){
			rect.origin.x -= i;
		}
        
        //--------------------------------------------
        UILabel* col1 = [[UILabel alloc] init];
        [col1.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
        [col1.layer setBorderWidth:1.0];
        col1.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        if (self.fontSize > 0) {
            col1.font = [UIFont fontWithName:@"Helvetica" size:self.fontSize];
        }
        col1.backgroundColor = [UIColor clearColor];
		col1.frame = rect;
        col1.textColor = [UIColor whiteColor];

		//SET LEFT RIGHT MARGINS & ALIGNMENT FOR THE LABEL
		NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//		style.alignment = NSTextAlignmentNatural;
        style.alignment = NSTextAlignmentCenter;
		style.headIndent = 10;
		style.firstLineHeadIndent = 10.0;
		style.tailIndent = -10.0;
		
		//SPECIAL TREATMENT FOR THE FIRST ROW
        if(self->numRows == 0){
//            style.alignment = NSTextAlignmentCenter;
            if (self.titleBackgroundColor == nil) {
                col1.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
            }else{
                col1.backgroundColor = self.titleBackgroundColor;
            }
        }
        else{
            if (i == 0 && self.firstColumnColor != nil) {
                col1.backgroundColor = self.firstColumnColor;
            }
        }
        
        if ([col1.textColor isEqual:col1.backgroundColor] || [col1.backgroundColor isEqual:[UIColor clearColor]]) {
            col1.textColor = [UIColor blackColor];
        }


		NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[record objectAtIndex:i] attributes:@{ NSParagraphStyleAttributeName : style}];
		
        col1.lineBreakMode = NSLineBreakByCharWrapping;
        col1.numberOfLines = 0;
		col1.attributedText = attrText;
		[col1 sizeToFit];
        
		
		//USED TO FIND HEIGHT OF LONGEST LABEL
        CGFloat h = col1.frame.size.height + 10;
        if(h > _rowHeight){
            _rowHeight = h;
        }
        
		//MAKE THE LABEL WIDTH SAME AS COLUMN'S WIDTH
		rect.size.width = colWidth;
        col1.frame = rect;
        
        [labels addObject:col1];
		
		//USED FOR SETTING THE NEXT COLUMN X POSITION
		dx += colWidth;
    }
    
    
	//MAKE ALL THE LABELS OF SAME HEIGHT AND THEN ADD TO VIEW
    for(uint i=0; i<labels.count; i++){
        UILabel* tempLabel = (UILabel*)[labels objectAtIndex:i];
        CGRect tempRect = tempLabel.frame;
        tempRect.size.height = _rowHeight;
		tempLabel.frame = tempRect;
        [self addSubview:tempLabel];
    }
	
    self->numRows++;
	
	
	//ADJUST y FOR BORDER OVERLAPPING BETWEEN ROWS
	self->dy += _rowHeight-1;
	
	
	//RESIZE THE MAIN VIEW TO FIT THE ROWS
	CGRect tempRect = self.frame;
	tempRect.size.height = dy;
	self.frame = tempRect;
}
@end
