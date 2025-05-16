import Ids "../../../base/Ids";
import Definitions "../../../base/Definitions";
import Types "../../../base/Types";
import GolfCourseEnums "../enums/GolfCourseEnums";
import GolfIds "../Ids";
import Enums "../../../base/Enums";

module GolfClubTypes {

    public type GolfClub = {
        id: GolfIds.GolfClubId;
        golfCourseId: GolfIds.GolfCourseId;
        name: Text;
        teeBookings: [TeeBooking];
        facilityReservations: [FacilityReservation];
        events: [ClubEvent];
        clubMenus: [ClubMenu];
        clubPros: [ClubPro]; 
        contacts: [Types.Contact];
        staffMembers: [CourseStaffMember];
        managementTeam: [CourseStaffMember];
        members: [MembershipProfile];
        facilities: [GolfCourseEnums.FacilityType];
        membershipOptions: [MembershipType];
        createdBy: Ids.PrincipalId;
        createdOn: Definitions.UnixTime;
    };

    public type TeeBooking = {
        golfers: [Ids.PrincipalId];
        teeTime: Definitions.UnixTime;
        tee: GolfIds.TeeGroupId;
        status: GolfCourseEnums.TeeBookingStatus;
    };

    public type FacilityReservation = {
        faciltyId: GolfCourseEnums.FacilityType;
        bookingTime: Definitions.UnixTime;
        durationNanoSeconds: Definitions.Nanoseconds;
        bookedBy: Ids.PrincipalId;
        guests: [Ids.PrincipalId];
    };

    public type ClubEvent = {
        eventDate: Definitions.UnixTime;
        invited: [Ids.PrincipalId];
        accepted: [Ids.PrincipalId];
        name: Text;
        description: Text;
        location: Text;
        address: Types.Address;
    };

    public type ClubMenu = {
        name: Text;
        items: [MenuItem];
        currency: Enums.Currency;
    };

    public type MenuItem = {
        id: GolfIds.MenuItemId;
        name: Text;
        description: Text;
        ingredients: [Text];
        allegyInformation: [Text];
        price: Nat;
        currency: Enums.Currency;
    };

    public type ClubPro = {
        id: Ids.PrincipalId;
        lessonPackages: [LessonPackage];
    };

    public type LessonPackage = {
        id: GolfIds.LessonPackageId;
        name: Text;
        description: Text;
        benefits: [Text];
        price: Nat;
        currency: Enums.Currency;
        duration: Definitions.Nanoseconds;
        lessonCount: Nat8;
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
    
    public type CourseStaffMember =
    {
        principalId: Ids.PrincipalId;
        role: Text;
        name: Text;
        email: Text;
        phone: Text;
    };



};
