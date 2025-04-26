import Ids "mo:waterway-mops/Ids";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import ICGCEnums "mo:waterway-mops/ICGCEnums";

module UserQueries = {

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

    public type GetManager = {
        principalId : Text;
    };

    public type GetManagerByUsername = {
        username : Text;
    };

    public type Manager = {
        principalId : Ids.PrincipalId;
        username : Text;
        profilePicture : ?Blob;
        profilePictureType : Text;
        createDate : Int;
        gameweeks : [FantasyTeamSnapshot];
        weeklyPosition : Int;
        monthlyPosition : Int;
        seasonPosition : Int;
        weeklyPositionText : Text;
        monthlyPositionText : Text;
        seasonPositionText : Text;
        weeklyPoints : Int16;
        monthlyPoints : Int16;
        seasonPoints : Int16;
    };

    public type GetTeamSetup = {
        principalId : Text;
    };

    public type GetICGCDataHash = {
        principalId : Ids.PrincipalId;
    };
};
