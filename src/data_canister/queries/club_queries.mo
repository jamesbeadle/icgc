import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballEnums "mo:waterway-mops/football/FootballEnums";
import Enums "mo:waterway-mops/Enums";

module ClubQueries {
    public type GetClubs = {
        leagueId: FootballIds.LeagueId;
    };

    public type Clubs = {
        leagueId: FootballIds.LeagueId;
        clubs: [Club];
    };

    public type Club = {
        id : FootballIds.ClubId;
        name : Text;
        friendlyName : Text;
        primaryColourHex : Text;
        secondaryColourHex : Text;
        thirdColourHex : Text;
        abbreviatedName : Text;
        shirtType : FootballEnums.ShirtType;
    };

    public type GetClubValueLeaderboard = {};

    public type ClubValueLeaderboard = {
        clubs: [ClubSummary]
    };

    public type ClubSummary = {
        clubId: FootballIds.ClubId;
        leagueId: FootballIds.LeagueId;
        clubName: Text;
        position: Nat;
        positionText: Text;
        totalValue: Nat;
        priorValue: Nat;
        primaryColour: Text;
        secondaryColour: Text;
        thirdColour: Text;
        shirtType: FootballEnums.ShirtType;
        gender: Enums.Gender;
        totalPlayers: Nat16;
        totalGoalkeepers: Nat16;
        totalDefenders: Nat16;
        totalMidfielders: Nat16;
        totalForwards: Nat16;
        totalGKValue: Nat;
        totalDFValue: Nat;
        totalMFValue: Nat;
        totalFWValue: Nat;
        mvp: MostValuablePlayer;
    };

    public type MostValuablePlayer = {
        id: FootballIds.PlayerId;
        firstName: Text;
        lastName: Text;
        value: Nat16;
    };
}