import Ids "mo:waterway-mops/base/ids";
import AppEnums "../enums";

module ProfileCommands = {

    public type CreateProfile = {
        username: Text;
        handicap: ?Float;
    };

    // TODO
    //add create profile but remove the others as you don't link in here
        //maybe you link back check with john

    public type LinkICGCProfile = {
        principalId : Ids.PrincipalId;
        icgcPrincipalId : Ids.PrincipalId;
        icgcMembershipType : AppEnums.MembershipType;
    };

    public type MembershipClaim = {
        membershipType : AppEnums.MembershipType;
        purchasedOn : Int;
        expiresOn : ?Int;
    };

    public type ICGCProfile = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : AppEnums.MembershipType;
        membershipClaims : [MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        nationalityId : ?Ids.CountryId;
    };

    public type CreateFriendRequest = {
        
    };

    public type DeleteFriendRequest = {

    };

    public type AcceptFriendRequest = {

    };

    public type RejectFriendRequest = {

    };

    public type RemoveFriend = {

    };

    

};
