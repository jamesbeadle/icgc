

import GolfIds "../../../../domain/golf/Ids";

module GolfClubQueries {
    public type GetGolfClubs = {
    };

    public type GolfClubs = {
        golfClubs: [GolfClub];
    };

    public type GolfClub = {
        id: GolfIds.GolfClubId;
        golfCourseId: GolfIds.GolfCourseId;
        name: Text;
    };

    /*

    make different queries to get: 

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
        
    */
}