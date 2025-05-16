import GolfIds "mo:waterway-mops/domain/golf/ids";
import Ids "mo:waterway-mops/base/ids";
import TournamentEnums "mo:waterway-mops/domain/golf/enums/golf-tournament-enums";
import ShotEnums "mo:waterway-mops/domain/golf/enums/golf-shot-enums";

module GolfTypes {

    public type ProGolfer = {
        id: GolfIds.ProGolferId;
        firstName: Text;
        lastName: Text;
        nationality: Ids.CountryId;
        worldRanking: Nat16;
    };  

    public type GolfCourse = {
        id: GolfIds.GolfCourseId;
        name: Text;
        holes: [GolfHole];
        par: Nat8;
        totalYardage: Nat16; 
        founded : Int;
        countryId : Ids.CountryId;
    };

    public type GolfHole = {
        holeNumber: Nat8;
        par: Nat8;
        strokeIndex: Nat8;
        yardage: Nat16;
    };

    public type Tournament = {
        id: GolfIds.TournamentId;
        name: Text;
        instances: [TournamentInstance];
    };

    public type TournamentInstance = {
        golfCourseId: GolfIds.GolfCourseId;
        year: Nat16;
        startDate: Int;
        endDate: Int;
        leaderboard: TournamentLeaderboard;
        stage: TournamentEnums.TournamentStage;
        populated: Bool;
    };

    public type TournamentLeaderboard = {
        totalEntries: Nat;
        entries: [TournamentLeaderboardEntry];
    };

    public type TournamentLeaderboardEntry = {
        golferId: GolfIds.ProGolferId;
        tournamentId: GolfIds.TournamentId;
        rounds: [GolfRound];
        totalShots: Nat;
    };

    public type GolfRound = {
        orderIndex: Nat8;
        teeTime: Int;
        hole1Score: HoleScore;
        hole2Score: HoleScore;
        hole3Score: HoleScore;
        hole4Score: HoleScore;
        hole5Score: HoleScore;
        hole6Score: HoleScore;
        hole7Score: HoleScore;
        hole8Score: HoleScore;
        hole9Score: HoleScore;
        hole10Score: HoleScore;
        hole11Score: HoleScore;
        hole12Score: HoleScore;
        hole13Score: HoleScore;
        hole14Score: HoleScore;
        hole15Score: HoleScore;
        hole16Score: HoleScore;
        hole17Score: HoleScore;
        hole18Score: HoleScore;
        totalShots: Nat;
    };

    public type DataTotals = {
        totalProGolfers: Nat;
        totalGolfClubs: Nat;
        totalTournaments: Nat;
    };

    public type HoleScore = {
        shotOrder: [ShotEnums.ShotCategory];
        shots: Nat8;
    };
};
