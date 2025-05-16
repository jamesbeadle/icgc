import Ids "mo:waterway-mops/base/Ids";
import AppIds "../Ids";

module GameCommands = {

    public type SendGameInvite = {
        sendTo: Ids.PrincipalId;
    };

    public type AcceptGameInvite = {
        inviteId: AppIds.GameInviteId;
    };

    public type CreateGame = {

    };

    public type UpdateGame = {

    };

    public type AddGamePrediction = {

    };

    public type AddGameScore = {

    };

    public type FinishGame = {

    };

    public type DeleteGame = {

    };

};