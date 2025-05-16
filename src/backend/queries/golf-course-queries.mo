import Ids "mo:waterway-mops/base/ids";
import GolfIds "mo:waterway-mops/domain/golf/ids";
module GolfCourseQueries {
    
    public type GetGolfCourse = {
        golfCourseId: GolfIds.GolfCourseId;
    };

    public type GolfCourse = {
        golfCourseId: GolfIds.GolfCourseId;
        name: Text;
        totalHoles: Nat8;
        founded: Int;
        countryId: Ids.CountryId;
        holes: [GolfHole];
        par: Nat8;
    };

    public type GolfHole = {
        holeNumber: Nat8;
        par: Nat8;
        strokeIndex: Nat8;
        yardage: Nat16;
    };

    public type ListGolfCourses = {
        page: Nat;
    };

    public type GolfCourses = {
        entries: [GolfCourseSummary];
        totalEntries: Nat;
        page: Nat;
    };

    public type GolfCourseSummary = {
        golfCourseId: GolfIds.GolfCourseId;
        name: Text;
        totalHoles: Nat8;
        founded: Int;
        countryId: Ids.CountryId;
        par: Nat8;
    };
    
    
}

  