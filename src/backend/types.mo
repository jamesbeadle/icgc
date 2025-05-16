import Ids "mo:waterway-mops/base/ids";
import BaseTypes "mo:waterway-mops/base/types";
import ICGCEnums "mo:waterway-mops/product/icgc/enums";
import Definitions "mo:waterway-mops/base/definitions";
import GolfIds "mo:waterway-mops/domain/golf/ids";
import AppEnums "./enums";
import AppIds "./ids"

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

  public type Friend = 
  {
    id: AppIds.FriendId;
    golferId: Ids.PrincipalId;
    friendId: Ids.PrincipalId;
    createdOn: Definitions.UnixTime;
  };

    public type FriendRequest = 
    {
      id: AppIds.FriendRequestId;
      createdOn: Definitions.UnixTime;
      senderId: Ids.PrincipalId;
      receipientId: Ids.PrincipalId;
      status: AppEnums.FriendRequestStatus
    };

    public type Game = 
    {
        id: AppIds.GameId;
        createUserId: Definitions.UnixTime;
        gameType: AppEnums.GameType;
        gameStatus: AppEnums.GameStatus;
    };

    public type GameInvite = 
    {
    };

    public type GamePlayer = 
    {
        playerId: Ids.PrincipalId;
        gameId: AppIds.GameId;
    };


     public type Profile = 
    {
        id: Ids.PrincipalId;
        username: Text;
        firstName: Text;
        lastName: Text;
        handicap: Float;
        homeGolfCourseId: GolfIds.GolfCourseId;
        termsAgreed: Bool;
        profilePicture: Blob;
        createdOn: Definitions.UnixTime;
    };


};
