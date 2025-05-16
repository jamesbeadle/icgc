import Ids "mo:waterway-mops/base/ids";
import ICGCEnums "mo:waterway-mops/product/icgc/enums";

module ProfileQueries = {

    public type GetProfile = {
        principalId : Ids.PrincipalId;
    };

    public type GetICGCLinkStatus = {
        principalId : Ids.PrincipalId;
    };

    public type CombinedProfile = {
        principalId : Ids.PrincipalId;
        username : Text;
        termsAccepted : Bool;
        profilePicture : ?Blob;
        profilePictureType : Text;
        createDate : Int;
        displayName : Text;
        membershipType : ICGCEnums.MembershipType;
        membershipClaims : [MembershipClaim];
        createdOn : Int;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
    };

    public type Profile = {
        principalId : Ids.PrincipalId;
        username : Text;
        termsAccepted : Bool;
        profilePicture : ?Blob;
        profilePictureType : Text;
        createDate : Int;
    };

    public type GetICGCProfile = {
        principalId : Ids.PrincipalId;
    };
    public type GetICGCMembership = {
        principalId : Ids.PrincipalId;
    };

    public type ICGCProfile = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : ICGCEnums.MembershipType;
        membershipClaims : [MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        nationalityId : ?Ids.CountryId;
    };

    public type ICGCLink = {
        membershipType : ICGCEnums.MembershipType;
        principalId : Ids.PrincipalId;
        linkStatus : ICGCEnums.ICGCLinkStatus;
        dataHash : Text;
    };

    public type MembershipClaim = {
        membershipType : ICGCEnums.MembershipType;
        purchasedOn : Int;
        expiresOn : ?Int;
    };

    public type GetICGCDataHash = {
        principalId : Ids.PrincipalId;
    };

    public type GetFriends = {

    };

    public type Friends = {

    };

    public type GetFriendRequests = {

    };

    public type FriendRequests = {

    };

    public type GetGames = {

    };

    public type Games = {

    };

    public type GetGolfShots = {
        
    };

    public type GolfShots = {

    };

    public type GetGolfers = {
        
    };

    public type Golfers = {

    };

    public type GetAverageYardages = {

    };

    public type AverageYardages = {
        
    };

    public type CheckUsernameAvailable = {
        username: Text;
    };

    public type UsernameAvailable = {
        available: Bool;
        username: Text;
    };
};
