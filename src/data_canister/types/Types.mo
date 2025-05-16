import ShotEnums "../enums/ShotEnums";

module GolfTypes {

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

};

        