#import "Kiwi.h"
#import "Ecosystem.h"

SPEC_BEGIN(EcosystemSpec)

describe(@"reset", ^{
    
    __block Ecosystem* ecosystem;
    __block id initialPopulationMock;
    
    beforeEach(^{
        initialPopulationMock = [KWMock nullMockForClass:[NSMutableSet class]];
        ecosystem = [[Ecosystem alloc] initWithRows:30 andColumns:40 andInitialPopulation:initialPopulationMock];
    });
    
    afterEach(^{
        //[Ecosystem release];
    });    
    
    it(@"should the initial population should not be nil", ^{
        id emptyWith3AliveMock = [KWMock nullMockForClass:[NSMutableSet class]];
        id aliveCellsMock = [KWMock nullMockForClass:[NSMutableSet class]];
        id nextGenAliveCellsMock = [KWMock nullMockForClass:[NSMutableSet class]];
        id nextGenEmptyWith3AliveMock = [KWMock nullMockForClass:[NSMutableSet class]];
        
        [ecosystem stub:@selector(initialPopulation) andReturn:initialPopulationMock];
        [ecosystem setValue:emptyWith3AliveMock forKey:@"emptyWith3Alive"];
        [ecosystem setValue:aliveCellsMock forKey:@"aliveCells"];
        [ecosystem setValue:nextGenAliveCellsMock forKey:@"nextGenAliveCells"];
        [ecosystem setValue:nextGenEmptyWith3AliveMock forKey:@"nextGenEmptyWith3Alive"];
        
        [[initialPopulationMock should] receive:@selector(removeAllObjects)];
        [[emptyWith3AliveMock should] receive:@selector(removeAllObjects)];
        [[aliveCellsMock should] receive:@selector(removeAllObjects)];
        [[nextGenAliveCellsMock should] receive:@selector(removeAllObjects)];
        [[nextGenEmptyWith3AliveMock should] receive:@selector(removeAllObjects)];
        
        [ecosystem reset];
    });    
});


/*- (id)initWithCoder:(NSCoder *)decoder
{
    int numberOfRows = [decoder decodeIntForKey:ROWS_ARCHIVE_KEY];
    int numberOfColumns = [decoder decodeIntForKey:COLUMNS_ARCHIVE_KEY];
    NSMutableSet* theInitialPopulation = [[decoder decodeObjectForKey:INITIAL_POPULATION_ARCHIVE_KEY] retain];
    
    return [self initWithRows:numberOfRows andColumns:numberOfColumns andInitialPopulation:theInitialPopulation];
}


- (void)encodeWithCoder:(NSCoder *)encoder
{    
    [encoder encodeInt:rows forKey:ROWS_ARCHIVE_KEY];
    [encoder encodeInt:columns forKey:COLUMNS_ARCHIVE_KEY];
    [encoder encodeObject:initialPopulation forKey:INITIAL_POPULATION_ARCHIVE_KEY];
}
*/
describe(@"initWithCoder:", ^{
    
    __block Ecosystem* ecosystem;
    __block NSMutableSet* initialPopulation;
    
    beforeEach(^{
        id decoderMock = [KWMock nullMockForClass:[NSCoder class]];
        initialPopulation = [NSMutableSet set];
        [decoderMock stub:@selector(decodeObjectForKey:) andReturn:initialPopulation withArguments:INITIAL_POPULATION_ARCHIVE_KEY];
        [decoderMock stub:@selector(decodeIntForKey:) andReturn:theValue(20) withArguments:ROWS_ARCHIVE_KEY];
        [decoderMock stub:@selector(decodeIntForKey:) andReturn:theValue(21) withArguments:COLUMNS_ARCHIVE_KEY];
        ecosystem = [[Ecosystem alloc] initWithCoder:decoderMock];
    });
    
    afterEach(^{
        [Ecosystem release];
    });    
    
    it(@"should initialize the initial population from the decoder", ^{
        STAssertTrue([ecosystem.initialPopulation isEqual:initialPopulation], @"should initialize the initial population from the decoder");    
    });
    
    it(@"should initialize the rows from the decoder", ^{
        STAssertTrue([[ecosystem valueForKey:@"rows"] intValue] == 20, @"should initialize the rows from the decoder");
    });
    
    it(@"should initialize the columns from the decoder", ^{
        STAssertTrue([[ecosystem valueForKey:@"columns"] intValue] == 21, @"should initialize the columns from the decoder");
    });

});


describe(@"encodeWithCoder:", ^{
    
    __block Ecosystem* ecosystem;
    __block id encoderMock;
    __block NSMutableSet* initialPopulation;
    
    beforeEach(^{
        encoderMock = [KWMock nullMockForClass:[NSCoder class]];
        initialPopulation = [NSMutableSet set];
        ecosystem = [[Ecosystem alloc] initWithRows:30 andColumns:32 andInitialPopulation:initialPopulation];
    });
    
    afterEach(^{
        [ecosystem release];
    });    
    
    it(@"should encode the value of the initial population", ^{
        [[encoderMock should] receive:@selector(encodeObject:forKey:) withArguments:initialPopulation, INITIAL_POPULATION_ARCHIVE_KEY];
        [ecosystem encodeWithCoder:encoderMock];
    });
    
    it(@"should encode the value of the rows", ^{
        [[encoderMock should] receive:@selector(encodeInt:forKey:) withArguments:theValue(30), ROWS_ARCHIVE_KEY];
        [ecosystem encodeWithCoder:encoderMock];       
    });
    
    it(@"should encode the value of the columns", ^{
        [[encoderMock should] receive:@selector(encodeInt:forKey:) withArguments:theValue(32), COLUMNS_ARCHIVE_KEY];
        [ecosystem encodeWithCoder:encoderMock];        
    });

});

SPEC_END