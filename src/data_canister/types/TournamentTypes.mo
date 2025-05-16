import Types "../../../base/Types";
import Enums "../../../base/Enums";
import GolfIds "../Ids";
import TournamentEnums "../enums/TournamentEnums";
import GolfTypes "Types";

module TournamentTypes {

    public type Tournament = {
        id: GolfIds.TournamentId;
        name: Text;
        instances: [TournamentInstance];
        brandInformation: Types.BrandInformation;
        format: TournamentEnums.TournamentFormat;
        tour: ?TournamentEnums.GolfTour;
        major: ?TournamentEnums.GolfMajor;
        gender: Enums.Gender;
    };

    public type TournamentInstance = {
        golfCourseId: GolfIds.GolfCourseId;
        year: Nat16;
        startDate: Int;
        endDate: Int;
        entrants: [GolfIds.ProGolferId];
        leaderboard: TournamentLeaderboard;
        stage: TournamentEnums.TournamentStage;
        populated: Bool;
        displayName: Text;
        sponsor: Text;
        sponsorBrandInformation: Types.BrandInformation;
    };

    public type TournamentLeaderboard = {
        totalEntries: Nat;
        entries: [TournamentLeaderboardEntry];
    };

    public type TournamentLeaderboardEntry = {
        golferId: GolfIds.ProGolferId;
        tournamentId: GolfIds.TournamentId;
        rounds: [GolfTypes.GolfRound];
        totalShots: Nat;
        usdPrizeAmount: Nat;
        btcPrizeAmount: Nat;
    };


};
