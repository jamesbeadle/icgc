import GolfIds "mo:waterway-mops/domain/golf/ids";
import TournamentEnums "mo:waterway-mops/domain/golf/enums/golf-tournament-enums";

module TournamentCommands {
    public type CreateTournament = {
        name: Text;
    };

    public type CreateTournamentInstance = {
        tournamentId: GolfIds.TournamentId;
        golfCourseId: GolfIds.GolfCourseId;
        year: Nat16;
        startDate: Int;
        endDate: Int;
    };

    public type AddTournamentResult = {
        tournamentId: GolfIds.TournamentId;
        year: Nat16;
        golferId: GolfIds.ProGolferId;
    };

    public type UpdateTournamentStage = {
        tournamentId: GolfIds.TournamentId;
        year: Nat16;
        stage: TournamentEnums.TournamentStage;
    };
}