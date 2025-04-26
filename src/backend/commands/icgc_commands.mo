import ICGCEnums "mo:waterway-mops/ICGCEnums";
import Ids "mo:waterway-mops/Ids";

module {
    public type NotifyAppofLink = {
        membershipType : ICGCEnums.MembershipType;
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICGCEnums.SubApp;
        icgcPrincipalId : Ids.PrincipalId;
    };

    public type UpdateICGCProfile = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICGCEnums.SubApp;
        membershipType : ICGCEnums.MembershipType;
    };

    public type VerifyICGCProfile = {
        principalId : Ids.PrincipalId;
    };
    public type VerifySubApp = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICGCEnums.SubApp;
        icgcPrincipalId : Ids.PrincipalId;
    };

    public type NotifyAppofRemoveLink = {
        subApp : ICGCEnums.SubApp;
        icgcPrincipalId : Ids.PrincipalId;
    };
};
