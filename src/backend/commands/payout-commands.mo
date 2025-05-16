import Enums "mo:waterway-mops/product/icgc/enums";
import GolfIds "mo:waterway-mops/domain/golf/ids";
import Definitions "mo:waterway-mops/base/definitions";

module PayoutCommands {
    public type PayoutLeaderboard = {
        tournamentId : GolfIds.TournamentId;
        year : Definitions.Year;
        app : Enums.SubApp;
    };

    public type Leaderboard = {
        entries : LeaderboardEntry;
    };

    public type LeaderboardEntry = {
        amount : Nat64;
    };
};
