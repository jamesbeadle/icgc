import List "mo:base/List";
import Ids "mo:waterway-mops/Ids";
import BaseTypes "mo:waterway-mops/BaseTypes";
import ICGCEnums "mo:waterway-mops/ICGCEnums";
import AppEnums "../enums/app_enums";

module AppTypes {

  public type DataHashes = {
    dataHashes : [BaseTypes.DataHash];
  };

  public type AppStatus = {
    onHold : Bool;
    version : Text;
  };

  public type MembershipClaim = {
    membershipType : AppEnums.MembershipType;
    purchasedOn : Int;
    expiresOn : ?Int;
  };

  public type ICGCLink = {
    membershipType : AppEnums.MembershipType;
    principalId : Ids.PrincipalId;
    linkStatus : ICGCEnums.ICGCLinkStatus;
    dataHash : Text;
  };

};
