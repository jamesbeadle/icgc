import GolfIds "../Ids";
import Ids "../../../base/Ids";
import Enums "../../../base/Enums";
import Definitions "../../../base/Definitions";
import GolfTypes "Types";

module ProGolferTypes {

        public type ProGolfer = {
            id: GolfIds.ProGolferId;
            firstName: Text;
            lastName: Text;
            nationality: Ids.CountryId;
            worldRanking: Nat16;
            tournamentEntries: [TournamentEntry];
            rankingHistory: [RankingSnapshot];
            earningsSnapshot: [EarningsSnapshot];
            majorWinCount: Nat8;
            tournamentWinCount: Nat16;
        };  

        public type TournamentEntry = {
            tournamentId: GolfIds.TournamentId;
            year: Definitions.Year;
            rounds: [GolfTypes.GolfRound];
            totalScore: Nat16;
            madeCut: Bool;
            finished: Nat;
            tiedFinish: Bool;
            earnings: Nat;
            earningsCurrency: Enums.Currency;
        };

        public type RankingSnapshot = {
            date: Int;
            ranking: Nat;
        };

        public type EarningsSnapshot = {
            date: Int;
            earnings: Nat;
            earningsCurrency: Enums.Currency;
        };


};
