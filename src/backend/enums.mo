module Enums {

  public type MembershipType = {
    #ANNUAL;
    #LIFETIME;
    #FOUNDING;
    #EXPIRED;
    #NOTCLAIMED;
    #NOTELIGIBLE;
  };

  public type FriendRequestStatus = 
  {
    #SENT;
    #ACCEPTED;
    #REJECTED;
  };

  public type GameType = {
    #STROKE_PLAY;
    #STABLEFORD;
    #MATCH_PLAY;
    #MULLIGANS;
    #BANDS;
  };

  public type GameStatus =
  {
    #NEW;
    #READY;
    #ACTIVE;
    #COMPLETE;
  };
  
}