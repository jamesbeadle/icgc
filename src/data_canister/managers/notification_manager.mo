import Iter "mo:base/Iter";
import Result "mo:base/Result";

import CanisterIds "mo:waterway-mops/CanisterIds";
import Enums "mo:waterway-mops/Enums";
import Ids "mo:waterway-mops/Ids";
import GolfEnums "mo:waterway-mops/golf/GolfEnums";
import BaseUtilities "mo:waterway-mops/BaseUtilities";

module {

  public class NotificationManager() {

    // Add all application_canister function definitions to all apps, implement and if not required then create different groups than the default notification group

    let defaultNotificationGroup: [GolfEnums.App] = [
        #GolfPad
        #JeffBets
    ];

    
    public func distributeNotification(notificationType: NotificationEnums.NotificationType, dto: NotificationCommands.Notification) : async Result.Result<(), Enums.Error>{
       
        switch(notificationType){
            case (#AddInitialFixtures){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        addInitialFixtureNotification : (dto: LeagueNotificationCommands.AddInitialFixtureNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#AddInitialFixtures foundDTO){
                            let _ = await application_canister.addInitialFixtureNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#BeginSeason){
            };
            case (#BeginGameweek){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        beginGameweekNotification : (dto: LeagueNotificationCommands.BeginGameweekNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#BeginGameweek foundDTO){
                            let _ = await application_canister.beginGameweekNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#CompleteGameweek){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        completeGameweekNotification : (dto: LeagueNotificationCommands.CompleteGameweekNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#CompleteGameweek foundDTO){
                            let _ = await application_canister.completeGameweekNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#CompleteFixture){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        finaliseFixtureNotification : (dto: LeagueNotificationCommands.CompleteFixtureNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#CompleteFixture foundDTO){
                            let _ = await application_canister.finaliseFixtureNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#FinaliseFixture){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        finaliseFixtureNotification : (dto: LeagueNotificationCommands.FinaliseFixtureNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#FinaliseFixture foundDTO){
                            let _ = await application_canister.finaliseFixtureNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#CompleteSeason){
                for(app in Iter.fromArray(defaultNotificationGroup)){

                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        completeSeasonNotification : (dto: LeagueNotificationCommands.CompleteSeasonNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#CompleteSeason foundDTO){
                            let _ = await application_canister.completeSeasonNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#RevaluePlayerUp){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        revaluePlayerUpNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#RevaluePlayerUp foundDTO){
                            let _ = await application_canister.revaluePlayerUpNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#RevaluePlayerDown){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        revaluePlayerDownNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#RevaluePlayerDown foundDTO){
                            let _ = await application_canister.revaluePlayerDownNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#LoanPlayer){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        loanPlayerNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#LoanPlayer foundDTO){
                            let _ = await application_canister.loanPlayerNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#RecallPlayer){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        recallPlayerNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#RecallPlayer foundDTO){
                            let _ = await application_canister.recallPlayerNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#ExpireLoan){
                for(app in Iter.fromArray(defaultNotificationGroup)){

                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        expireLoanNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#ExpireLoan foundDTO){
                            let _ = await application_canister.expireLoanNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#TransferPlayer){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        transferPlayerNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#TransferPlayer foundDTO){
                            let _ = await application_canister.transferPlayerNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#SetFreeAgent){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        setFreeAgentNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#SetFreeAgent foundDTO){
                            let _ = await application_canister.setFreeAgentNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#RetirePlayer){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        retirePlayerNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#RetirePlayer foundDTO){
                            let _ = await application_canister.retirePlayerNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#ChangePlayerPosition){
                for(app in Iter.fromArray(defaultNotificationGroup)){
                    let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                      return #err(#FailedInterCanisterCall);  
                    };
                    let application_canister = actor (appPrincipalId) : actor {
                        changePlayerPositionNotification : (dto: PlayerNotificationCommands.PlayerChangeNotification) -> async Result.Result<(), Enums.Error>;
                    };
                    switch(dto){
                        case (#ChangePlayerPosition foundDTO){
                            let _ = await application_canister.changePlayerPositionNotification(foundDTO);
                        };
                        case (_){}
                    };
                };
            };
            case (#CreateClub){};
            case (#UpdateClub){};
            case (#PromoteClub){};
            case (#RelegateClub){};
            case (#CreateLeague){};
            case (#UpdateLeague){};
            case (#CreatePlayer){};
            case (#UpdatePlayer){};
            case (#InjuryUpdated){};
            case (#UnretirePlayer){};
        };
        return #ok();
    }

  };

};
