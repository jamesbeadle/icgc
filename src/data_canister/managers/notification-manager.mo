import Iter "mo:base/Iter";
import Result "mo:base/Result";
import { message } "mo:base/Error";

import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import Enums "mo:waterway-mops/base/enums";
import AppEnums "mo:waterway-mops/product/wwl/enums";
import Ids "mo:waterway-mops/base/ids";
import ICGCEnums "mo:waterway-mops/product/icgc/enums";
import LogManager "mo:waterway-mops/product/wwl/log-management/manager";
import ProGolferNotificationCommands "mo:waterway-mops/product/icgc/data-canister-notification-commands/pro-golfer-notification-commands";
import TournamentNotificationCommands "mo:waterway-mops/product/icgc/data-canister-notification-commands/tournament-notification-commands";

module {

    public class NotificationManager() {
        let logsManager = LogManager.LogManager();
        // Add all application_canister function definitions to all apps, implement and if not required then create different groups than the default notification group

        let defaultNotificationGroup : [ICGCEnums.SubApp] = [
            #GolfPad,
            #JeffBets
        ];

        public func distributeNotification(notificationType : ICGCEnums.NotificationType, dto : ICGCEnums.NotificationType) : async Result.Result<(), Enums.Error> {

            try {
                switch (notificationType) {
                    case (#ProGolferScoreAdded) {
                        for (app in Iter.fromArray(defaultNotificationGroup)) {
                            let ?appPrincipalId = BaseUtilities.getAppCanisterId(app) else {
                                return #err(#FailedInterCanisterCall);
                            };
                            let application_canister = actor (appPrincipalId) : actor {
                                proGolferScoreAddedNotification : (dto : ProGolferNotificationCommands.ScoreAddedNotification) -> async Result.Result<(), Enums.Error>;
                            };
                            switch (dto) {
                                case (#AddInitialFixtures foundDTO) {
                                    let _ = await application_canister.proGolferScoreAddedNotification(foundDTO);
                                };
                                case (_) {};
                            };
                        };
                    };
                    case (#RoundBegun) {};
                    case (#RoundComplete) {};
                    case (#TournamentBegun) {};
                    case (#TournamentComplete) {};
                };
                return #ok();
            } catch (e) {
                let _ = await logsManager.addApplicationLog({
                    app = #ICGC;
                    logType = #Error;
                    title = "Failed to distribute notification";
                    detail = message(e);
                    error = ?#CallFailed;
                });
            };
        }

    };

};
