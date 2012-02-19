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

SPEC_END