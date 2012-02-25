#import "Kiwi.h"
#import "Matrix2DCoordenate.h"


SPEC_BEGIN(Matrix2DCoordinateSpec)

describe(@"initWithCoder:", ^{
    
    __block Matrix2DCoordenate* coordinate;
    
    beforeEach(^{
        id decoderMock = [KWMock nullMockForClass:[NSCoder class]];
        [decoderMock stub:@selector(decodeIntForKey:) andReturn:theValue(5) withArguments:ROW_ARCHIVE_KEY];
        [decoderMock stub:@selector(decodeIntForKey:) andReturn:theValue(7) withArguments:COLUMN_ARCHIVE_KEY];
        coordinate = [[Matrix2DCoordenate alloc] initWithCoder:decoderMock];
    });
    
    afterEach(^{
        [coordinate release];
    });    
    
    it(@"should initialize the row from the decoder", ^{
        STAssertTrue(coordinate.row == 5, @"should initialize the row from the decoder");
    });

    it(@"should initialize the column from the decoder", ^{
        STAssertTrue(coordinate.column == 7, @"should initialize the column from the decoder");
    });
});


describe(@"encodeWithCoder:", ^{
    
    __block Matrix2DCoordenate* coordinate;
    __block id encoderMock;
    
    beforeEach(^{
        encoderMock = [KWMock nullMockForClass:[NSCoder class]];
        coordinate = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:9];
    });
    
    afterEach(^{
        [coordinate release];
    });    
    
    it(@"should encode the value of the row", ^{
        [[encoderMock should] receive:@selector(encodeInt:forKey:) withArguments:theValue(4), ROW_ARCHIVE_KEY];
        [coordinate encodeWithCoder:encoderMock];
    });
    
    it(@"should encode the value of the column", ^{
        [[encoderMock should] receive:@selector(encodeInt:forKey:) withArguments:theValue(9), COLUMN_ARCHIVE_KEY];
        [coordinate encodeWithCoder:encoderMock];        
    });
});
SPEC_END