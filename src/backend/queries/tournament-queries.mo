import GolfIds "mo:waterway-mops/domain/golf/ids";
import TournamentEnums "mo:waterway-mops/domain/golf/enums/golf-tournament-enums";
import ShotEnums "mo:waterway-mops/domain/golf/enums/golf-shot-enums";

module TournamentQueries {
    
    public type GetTournament = {
        tournamentId: GolfIds.TournamentId;
    };

    public type Tournament = {
        tournamentId: GolfIds.TournamentId;
    };
    
    public type GetTournamentInstance = {
        tournamentId: GolfIds.TournamentId;
        year: Nat16;
    };

    public type TournamentInstance = {
        tournamentId: GolfIds.TournamentId;
        year: Nat16;
        populated: Bool;
        golfCourseId: GolfIds.GolfCourseId;
        startDate: Int;
        endDate: Int;
        leaderboard: TournamentLeaderboard;
        stage: TournamentEnums.TournamentStage;
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

    public type HoleScore = {
        shotOrder: [ShotEnums.ShotCategory];
        shots: Nat8;
    };

    public type ListTournaments = {
        page: Nat;
    };

    public type Tournaments = {
        entries: [TournamentSummary];
        totalEntries: Nat;
        page: Nat;
    };

    public type TournamentSummary = {
        tournamentId: GolfIds.TournamentId;
        name: Text;
    };
    
}

  