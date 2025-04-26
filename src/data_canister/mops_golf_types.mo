import MopsGolfIds "mops_golf_ids";
import Ids "mo:waterway-mops/Ids";

module GolfTypes {

    public type ProGolfer = {
        id: MopsGolfIds.GolferId;
        firstName: Text;
        lastName: Text;
        nationality: Ids.CountryId;
        worldRanking: Nat16;
    };  

    public type GolfCourse = {
        id: MopsGolfIds.GolfCourseId;
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
};
