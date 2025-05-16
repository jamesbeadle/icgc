import Iter "mo:base/Iter";
import Result "mo:base/Result";

import CanisterIds "mo:waterway-mops/product/wwl/CanisterIds";
import Enums "mo:waterway-mops/base/Enums";
import AppEnums "mo:waterway-mops/product/wwl/Enums";
import Ids "mo:waterway-mops/base/Ids";

module {

  public class NotificationManager() {

    // Add all application_canister function definitions to all apps, implement and if not required then create different groups than the default notification group

    let defaultNotificationGroup: [(AppEnums.WaterwayLabsApp, Ids.CanisterId)] = [
        (#GolfPad, CanisterIds.GOLFPAD_BACKEND_CANISTER_ID)
        (#JeffBets, CanisterIds.JEFF_BETS_BACKEND_CANISTER_ID)
    ];

    
    public func distributeNotification(notificationType: NotificationEnums.NotificationType, dto: NotificationCommands.Notification) : async Result.Result<(), Enums.Error>{
       
        switch(notificationType){
            case (#AddTournamentInstance){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let application_canister = actor (app.1) : actor {
                        addInitialFixtureNotification : (dto: LeagueNotificationCommands.AddInitialFixtureNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#AddTournamentInstance foundDTO){
                            let _ = await application_canister.addInitialFixtureNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#BeginTournament){};
            case (#TournamentRoundComplete){};
            case (#EndTournament){};
        };
        return #ok();
    }

  };

};
