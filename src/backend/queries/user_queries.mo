import Ids "mo:waterway-mops/Ids";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import ICFCEnums "mo:waterway-mops/ICFCEnums";

module UserQueries = {

    public type GetProfile = {
        principalId : Ids.PrincipalId;
    };

    public type GetICFCLinkStatus = {
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
        membershipType : ICFCEnums.MembershipType;
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

    public type GetICFCProfile = {
        principalId : Ids.PrincipalId;
    };
    public type GetICFCMembership = {
        principalId : Ids.PrincipalId;
    };

    public type ICFCProfile = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : ICFCEnums.MembershipType;
        membershipClaims : [MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        nationalityId : ?Ids.CountryId;
    };

    public type ICFCLink = {
        membershipType : ICFCEnums.MembershipType;
        principalId : Ids.PrincipalId;
        linkStatus : ICFCEnums.ICFCLinkStatus;
        dataHash : Text;
    };

    public type MembershipClaim = {
        membershipType : ICFCEnums.MembershipType;
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

    public type GetICFCDataHash = {
        principalId : Ids.PrincipalId;
    };
};
