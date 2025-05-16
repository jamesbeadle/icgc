
import Ids "mo:waterway-mops/base/Ids";
import GolfIds "mo:waterway-mops/domain/golf/Ids";

module GolferCommands {
    public type CreateGolfer = {
        firstName: Text;
        lastName: Text;
        nationality: Ids.CountryId;
        worldRanking: Nat16;
    };

    public type UpdateGolfer = {
        golferId: GolfIds.ProGolferId;
        firstName: Text;
        lastName: Text;
        nationality: Ids.CountryId;
        worldRanking: Nat16;
    };
}