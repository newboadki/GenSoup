#import "Kiwi.h"
#import "Cell.h"
#import "Matrix2DCoordenate.h"

SPEC_BEGIN(CellSpec)

describe(@"initWithCoder:", ^{
    
    __block Cell* cell;
    __block Matrix2DCoordenate* coord;
    
    beforeEach(^{
        id decoderMock = [KWMock nullMockForClass:[NSCoder class]];
        coord = [[[Matrix2DCoordenate alloc] initWithRow:23 andColumn:76] autorelease];
        [decoderMock stub:@selector(decodeObjectForKey:) andReturn:coord withArguments:COORDINATE_ARCHIVE_KEY];
        [decoderMock stub:@selector(decodeIntForKey:) andReturn:theValue(-1) withArguments:ORGANISM_ID_ARCHIVE_KEY];
        cell = [[Cell alloc] initWithCoder:decoderMock];
    });
    
    afterEach(^{
        [cell release];
    });    
    
    it(@"should initialize the coordinate from the decoder", ^{
        STAssertTrue(cell.coordinate.row == 23, @"should initialize the row from the decoder");
        STAssertTrue(cell.coordinate.column == 76, @"should initialize the row from the decoder");
    });
    
    it(@"should initialize the organismId from the decoder", ^{
        STAssertTrue(cell.organismID == -1, @"should initialize the column from the decoder");
    });
});


describe(@"encodeWithCoder:", ^{
    
    __block Cell* cell;
    __block id encoderMock;
    __block Matrix2DCoordenate* coord;
    
    beforeEach(^{
        encoderMock = [KWMock nullMock];
        coord = [[Matrix2DCoordenate alloc] initWithRow:23 andColumn:76];
        cell = [[Cell alloc] initWithCoordinate:coord andOrganismID:-1];
        [coord release];
    });
    
    afterEach(^{
        [cell release];
    });    
    
    it(@"should encode the value of the coordinate", ^{
        [[encoderMock should] receive:@selector(encodeObject:forKey:) withArguments:coord, COORDINATE_ARCHIVE_KEY];
        [cell encodeWithCoder:encoderMock];
    });
    
    it(@"should encode the value of the organismId", ^{
        [[encoderMock should] receive:@selector(encodeInt:forKey:) withArguments:theValue(-1), ORGANISM_ID_ARCHIVE_KEY];
        [cell encodeWithCoder:encoderMock];        
    });
});
SPEC_END