import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/ICGCEnums";

module ICGCQUeries {
  public type GetICGCLinks = {};

  public type ICGCLinks = {
    icgcPrincipalId : Ids.PrincipalId;
    subAppUserPrincipalId : Ids.PrincipalId;
    membershipType : Enums.MembershipType;
    subApp : Enums.SubApp;
  };

};