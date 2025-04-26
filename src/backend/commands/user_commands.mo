import Ids "mo:waterway-mops/Ids";
import AppEnums "../enums/app_enums";

module UserCommands = {

    public type LinkICFCProfile = {
        principalId : Ids.PrincipalId;
        icfcPrincipalId : Ids.PrincipalId;
        icfcMembershipType : AppEnums.MembershipType;
    };

    public type MembershipClaim = {
        membershipType : AppEnums.MembershipType;
        purchasedOn : Int;
        expiresOn : ?Int;
    };

    public type ICFCProfile = {
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

};
