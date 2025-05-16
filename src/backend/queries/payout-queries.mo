import Definitions "mo:waterway-mops/base/definitions";
import Ids "mo:waterway-mops/base/ids";
import ICGCEnums "mo:waterway-mops/product/icgc/enums";
import GolfIds "mo:waterway-mops/domain/golf/ids";
import LeaderboardPayoutCommands "mo:waterway-mops/product/icgc/inter-app-call-commands";

module PayoutQueries {
    public type GetLeaderboardRequests = {};

    public type LeaderboardRequests = {
        requests : [PayoutRequest];
        totalRequest : Nat;
    };

    public type PayoutRequest = {
        tournamentId : GolfIds.TournamentId;
        year : Definitions.Year;
        app : Text;
        leaderboard : [LeaderboardPayoutCommands.LeaderboardEntry];
        token : Text;
        totalEntries : Nat;
        totalEntriesPaid : Nat;
    };

    public type GetICGCLinks = {};

    public type ICGCLinks = {
        icgcPrincipalId : Ids.PrincipalId;
        subAppUserPrincipalId : Ids.PrincipalId;
        membershipType : ICGCEnums.MembershipType;
        subApp : ICGCEnums.SubApp;
    };

};
