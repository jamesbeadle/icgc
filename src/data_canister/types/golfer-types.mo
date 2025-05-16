
module GolferTypes {


    public type ClubProfile = {
        golferProfile: GolferProfile;
        homeCourseId: GolfIds.GolfCourseId;
        memberships: [ClubMemberships]
    };
    
    public type ClubMembership = {
        startDate: Int;
        endDate: Int;
        fee: Nat;
        feeCurrency: Currency;
    };
    
    public type ClubProfile = {
        golferProfile: GolferProfile;
        homeCourseId: GolfIds.GolfCourseId;
        memberships: [ClubMemberships]
    };

    public type GolfShot =
    {
        index: Nat8;
        club: ?GolfEnums.Club;
        yardage: ?Nat16;
        lie: ?GolfEnums.Lie;
        shotIntention: ?ShotIntention;
        shotResult: ?ShotResult;
        weatherType: ?WeatherType;
        shotStartPosition: ?ShotStartPosition;
        shotEndPosition: ?ShotEndPosition;
        swingLength: ?SwingLength;
        dateTime: ?ShotTime;
    };

    public type ClubMembership = {
        startDate: Int;
        endDate: Int;
        fee: Nat;
        feeCurrency: Currency;
    };

};
