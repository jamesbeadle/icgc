import Ids "../../../base/Ids";
import Definitions "../../../base/Definitions";
import Types "../../../base/Types";
import GolfCourseEnums "../enums/GolfCourseEnums";
import GolfDefinitions "../Definitions";
import GolfIds "../Ids";
import Enums "../../../base/Enums";

module GolfCourseTypes {

    public type GolfCourse =
    {
        id: GolfIds.GolfCourseId;
        name: Text;
        teeGroups: [TeeGroup];
        visitorInformation: Text;
        contacts: [Types.Contact];
        members: [MembershipProfile];
        facilities: [GolfCourseEnums.FacilityType];
        membershipOptions: [MembershipType];
        address: ?Types.Address;
        openingHours: [OpeningHour];
        branding: ?Types.BrandInformation;
        foundedOn: ?Definitions.UnixTime;
        foundedYear: ?Definitions.Year;
        courseImage: ?Blob;
        bannerImage: ?Blob;
        flyoverVideo: ?Blob;
        competitions: [ClubCompetition];
        boards: [ClubBoard];
        courseRecords: [CourseRecord];
        albums: [CourseAlbum];
        courseNewsFeed: [NewsFeedItem];
        status: GolfCourseEnums.CourseStatus;
        countryId : Ids.CountryId;
        createdBy: Ids.PrincipalId;
        createdOn: Definitions.UnixTime;
    };

    public type MembershipType = {
        name: Text;
        description: Text;
        benefits: Text;
        price: Nat;
        currency: Enums.Currency;
    };

    public type MembershipProfile = {
        principalId: Ids.PrincipalId;
        joined: Definitions.UnixTime;
        expires: Definitions.UnixTime;
        membershipType: MembershipType;
    };

    public type ClubCompetition = {
        id: GolfIds.ClubCompetitionId;
        title: Text;
        description: Text;
        results: [CompetitionResult];
        competitionType: GolfCourseEnums.CompetitionType;
    };

    public type CompetitionResult = {
        year: Definitions.Year;
        entries: CompetitionEntry;
    };

    public type CompetitionEntry = {
        member: Ids.PrincipalId;
        rounds: [CompetitionRound];
    };

    public type CompetitionRound = {
        holes: [CompetitionHole];
    };

    public type CompetitionHole = {
        holeNumber: GolfDefinitions.HoleNumber;
        shots: Nat8;
        score: Nat8;
    };  

    public type ClubBoard = {
        id: GolfIds.ClubBoardId;
        title: Text;
        description: Text;
        winners: [BoardWinner];
    };

    public type BoardWinner = {
        year: Definitions.Year;
        winner: Text;
        principalId: ?Ids.PrincipalId;
    };

    public type CourseRecord = {
        id: GolfIds.CourseRecordId;
        recordName: Text;
        teeGroup: GolfIds.TeeGroupId;
        score: Int;
        achievedOn: Definitions.UnixTime;
    };

    public type CourseAlbum =
    {
        id: GolfIds.CourseAlbumId;
        index: Nat;
        name: Text;
        courseImages: [CourseMediaItem]
    };

    public type CourseMediaItem =
    {
        id: GolfIds.CourseMediaItemId;
        blob: Blob;
        holeNumber: ?GolfDefinitions.HoleNumber;
        title: Text;
        description: Text;
        mediaType: Enums.MediaType;
    };

    public type NewsFeedItem = {
        id: GolfIds.NewsFeedItemId;
        title: Text;
        description: Text;
        mediaItem: ?CourseMediaItem;
    };

};
