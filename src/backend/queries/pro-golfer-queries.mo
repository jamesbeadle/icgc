import GolfIds "mo:waterway-mops/domain/golf/ids";
import Ids "mo:waterway-mops/base/ids";

module ProGolferQueries {
    
    public type GetProGolfer = {
        golferId: GolfIds.ProGolferId;
    };

    public type ProGolfer = {
        golferId: GolfIds.ProGolferId;
        firstName: Text;
        lastName: Text;
        nationality: Ids.CountryId;
        worldRanking: Nat16;
    };

    public type ListProGolfers = {
        page: Nat;
    };

    public type ProGolfers = {
        entries: [ProGolferSummary];
        totalEntries: Nat;
        page: Nat;
    };

    public type ProGolferSummary = {
        id: GolfIds.ProGolferId;
        firstName: Text;
        lastName: Text;
        nationality: Ids.CountryId;
        worldRanking: Nat16;
    };
    
}

  