import List "mo:base/List";
import Ids "mo:waterway-mops/Ids";
import BaseTypes "mo:waterway-mops/BaseTypes";
import ICFCEnums "mo:waterway-mops/ICFCEnums";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
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
    linkStatus : ICFCEnums.ICFCLinkStatus;
    dataHash : Text;
  };

};
