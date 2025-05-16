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


    public type FriendRequestStatus = 
    {
        #SENT;
        #ACCEPTED;
        #REJECTED;
    };

    public type GameStatus =
    {
        #NEW;
        #READY;
        #ACTIVE;
        #COMPLETE;
    };

 public type Friend
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int GolferId { get; set; }

        [Required]
        public int FriendId { get; set; }

        [Required]
        public DateTime CreatedOn { get; set; }
    }

    public type FriendRequest
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public DateTime CreatedOn { get; set; }

        [Required]
        public int SenderId {  get; set; }

        [Required]
        public int ReceipientId { get; set; }

        public FriendRequestStatus Status { get; set; }
    }

    public type Game
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int CreateUserId {  get; set; }

        [Required]
        public DateTime CreatedOn { get; set; }

        [Required]
        public GameType GameType { get; set; }

        public GameStatus GameStatus { get; set; }

        
    }

    public type GameInvite
    {
    }

    public type GamePlayer
    {
        public int PlayerId { get; set; }

        public int GameId { get; set; }
    }


     public type Golfer
    {
        public int Id { get; set; }
        public string? Uid { get; set; }
        public string Username { get; set; } = string.Empty;
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public decimal? Handicap { get; set; }
        public int? HomeGolfCourseId { get; set; }
        public bool TermsAgreed { get; set; } = false;
        public string? ProfilePicture { get; set; }
        public DateTime? CreatedOn { get; set; }
        public DateTime? TermsAccepted { get; set; }    
        public virtual GolfCourse? HomeGolfCourse { get; set; }
    }


};
