import Ids "mo:waterway-mops/base/ids";
import Enums "mo:waterway-mops/product/icgc/enums";

module ICGCQUeries {
  public type GetICGCLinks = {};

  public type ICGCLinks = {
    icgcPrincipalId : Ids.PrincipalId;
    subAppUserPrincipalId : Ids.PrincipalId;
    membershipType : Enums.MembershipType;
    subApp : Enums.SubApp;
  };

};