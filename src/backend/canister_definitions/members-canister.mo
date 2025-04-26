
/* ----- Mops Packages ----- */

import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Int16 "mo:base/Int16";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import TrieMap "mo:base/TrieMap";


/* ----- Queries ----- */

import UserQueries "../queries/user_queries";
import AppQueries "../queries/app_queries";


/* ----- Commands ----- */

import UserCommands "../commands/user_commands";


/* ----- Only Stable Variables Should Use Types ----- */

import AppTypes "../types/app_types";


/* ----- Application Environment & Utility Files ----- */ 

import PickTeamUtilities "../utilities/pick_team_utilities";
import Environment "../Environment";


actor class _ManagerCanister() {


  /* ----- Stable Canister Bucket Definitions ----- */ 

  private stable var managerGroup1 : [AppTypes.Manager] = [];
  private stable var managerGroup2 : [AppTypes.Manager] = [];
  private stable var managerGroup3 : [AppTypes.Manager] = [];
  private stable var managerGroup4 : [AppTypes.Manager] = [];
  private stable var managerGroup5 : [AppTypes.Manager] = [];
  private stable var managerGroup6 : [AppTypes.Manager] = [];
  private stable var managerGroup7 : [AppTypes.Manager] = [];
  private stable var managerGroup8 : [AppTypes.Manager] = [];
  private stable var managerGroup9 : [AppTypes.Manager] = [];
  private stable var managerGroup10 : [AppTypes.Manager] = [];
  private stable var managerGroup11 : [AppTypes.Manager] = [];
  private stable var managerGroup12 : [AppTypes.Manager] = [];


  /* ----- Stable Canister Variables ----- */ 
  private stable var stable_manager_group_indexes : [(Ids.PrincipalId, Nat8)] = [];
  private stable var activeGroupIndex : Nat8 = 0;
  private stable var totalManagers = 0;

  private var managerGroupIndexes : TrieMap.TrieMap<Ids.PrincipalId, Nat8> = TrieMap.TrieMap<Ids.PrincipalId, Nat8>(Text.equal, Text.hash);

  public shared ({ caller }) func updateTeamSelection(dto : UserCommands.SaveFantasyTeam, transfersAvailable : Nat8, newBankBalance : Nat16, currentGameweek: IcfcTypes.GameweekNumber) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeTeamSelection(dto, manager, transfersAvailable, newBankBalance, currentGameweek));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {};
        };
      };
    };
    return #ok;

  };

  private func mergeTeamSelection(dto : UserCommands.SaveFantasyTeam, manager : AppTypes.Manager, transfersAvailable : Nat8, newBankBalance : Nat16, currentGameweek: IcfcTypes.GameweekNumber) : AppTypes.Manager {
    
    var transferWindowGameweek = manager.transferWindowGameweek;
    if(transferWindowGameweek == 0 and dto.playTransferWindowBonus){
      transferWindowGameweek := currentGameweek;
    };
    
    return {
      principalId = manager.principalId;
      username = manager.username;
      favouriteClubId = manager.favouriteClubId;
      createDate = manager.createDate;
      termsAccepted = manager.termsAccepted;
      profilePicture = manager.profilePicture;
      transfersAvailable = transfersAvailable;
      monthlyBonusesAvailable = manager.monthlyBonusesAvailable;
      bankQuarterMillions = newBankBalance;
      playerIds = dto.playerIds;
      captainId = dto.captainId;
      goalGetterGameweek = manager.goalGetterGameweek;
      goalGetterPlayerId = manager.goalGetterPlayerId;
      passMasterGameweek = manager.passMasterGameweek;
      passMasterPlayerId = manager.passMasterPlayerId;
      noEntryGameweek = manager.noEntryGameweek;
      noEntryPlayerId = manager.noEntryPlayerId;
      teamBoostGameweek = manager.teamBoostGameweek;
      teamBoostClubId = manager.teamBoostClubId;
      safeHandsGameweek = manager.safeHandsGameweek;
      safeHandsPlayerId = manager.safeHandsPlayerId;
      captainFantasticGameweek = manager.captainFantasticGameweek;
      captainFantasticPlayerId = manager.captainFantasticPlayerId;
      oneNationGameweek = manager.oneNationGameweek;
      oneNationCountryId = manager.oneNationCountryId;
      prospectsGameweek = manager.prospectsGameweek;
      braceBonusGameweek = manager.braceBonusGameweek;
      hatTrickHeroGameweek = manager.hatTrickHeroGameweek;
      transferWindowGameweek;
      history = manager.history;
      profilePictureType = manager.profilePictureType;
      canisterId = manager.canisterId;
    };
  };

  public shared ({ caller }) func useBonus(dto : UserCommands.PlayBonus, monthlyBonuses : Nat8, gameweek: IcfcTypes.GameweekNumber) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeBonus(dto, manager, gameweek, monthlyBonuses));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {};
        };
      };
    };
    return #ok;

  };
  
  public shared ({ caller }) func updateFavouriteClub(dto : UserCommands.SetFavouriteClub) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);
    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {
        switch (foundGroupIndex) {
          case 0 {
            for (manager in Iter.fromArray(managerGroup1)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup1 := Buffer.toArray(managerBuffer);
          };
          case 1 {
            for (manager in Iter.fromArray(managerGroup2)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup2 := Buffer.toArray(managerBuffer);
          };
          case 2 {
            for (manager in Iter.fromArray(managerGroup3)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup3 := Buffer.toArray(managerBuffer);
          };
          case 3 {
            for (manager in Iter.fromArray(managerGroup4)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup4 := Buffer.toArray(managerBuffer);
          };
          case 4 {
            for (manager in Iter.fromArray(managerGroup5)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup5 := Buffer.toArray(managerBuffer);
          };
          case 5 {
            for (manager in Iter.fromArray(managerGroup6)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup6 := Buffer.toArray(managerBuffer);
          };
          case 6 {
            for (manager in Iter.fromArray(managerGroup7)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup7 := Buffer.toArray(managerBuffer);
          };
          case 7 {
            for (manager in Iter.fromArray(managerGroup8)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup8 := Buffer.toArray(managerBuffer);
          };
          case 8 {
            for (manager in Iter.fromArray(managerGroup9)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup9 := Buffer.toArray(managerBuffer);
          };
          case 9 {
            for (manager in Iter.fromArray(managerGroup10)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup10 := Buffer.toArray(managerBuffer);
          };
          case 10 {
            for (manager in Iter.fromArray(managerGroup11)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup11 := Buffer.toArray(managerBuffer);
          };
          case 11 {
            for (manager in Iter.fromArray(managerGroup12)) {
              if (manager.principalId == dto.principalId) {
                managerBuffer.add(mergeManagerFavouriteClub(manager, dto.favouriteClubId));
              } else {
                managerBuffer.add(manager);
              };
            };
            managerGroup12 := Buffer.toArray(managerBuffer);
          };
          case _ {};
        };
      };
    };

    return #ok();
  };

  public shared ({ caller }) func getManager(managerPrincipal : Text) : async ?AppTypes.Manager {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerGroupIndex = managerGroupIndexes.get(managerPrincipal);
    switch (managerGroupIndex) {
      case (null) {
        return null;
      };
      case (?foundIndex) {
        switch (foundIndex) {
          case (0) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup1)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (1) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup2)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (2) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup3)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (3) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup4)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (4) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup5)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (5) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup6)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (6) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup7)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (7) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup8)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (8) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup9)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (9) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup10)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (10) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup11)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case (11) {
            for (manager in Iter.fromArray<AppTypes.Manager>(managerGroup12)) {
              if (manager.principalId == managerPrincipal) {
                return ?manager;
              };
            };
          };
          case _ {

          };
        };
        return null;
      };
    };
  };
  
  public shared ({ caller }) func getFantasyTeamSnapshot(dto : UserQueries.GetFantasyTeamSnapshot) : async ?UserQueries.FantasyTeamSnapshot {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    let managerGroupIndex = managerGroupIndexes.get(dto.principalId);

    var managers : [AppTypes.Manager] = [];

    switch (managerGroupIndex) {
      case (null) {};
      case (?foundGroupIndex) {

        switch (foundGroupIndex) {
          case 0 {
            managers := managerGroup1;
          };
          case 1 {
            managers := managerGroup2;
          };
          case 2 {
            managers := managerGroup3;
          };
          case 3 {
            managers := managerGroup4;
          };
          case 4 {
            managers := managerGroup5;
          };
          case 5 {
            managers := managerGroup6;
          };
          case 6 {
            managers := managerGroup7;
          };
          case 7 {
            managers := managerGroup8;
          };
          case 8 {
            managers := managerGroup9;
          };
          case 9 {
            managers := managerGroup10;
          };
          case 10 {
            managers := managerGroup11;
          };
          case 11 {
            managers := managerGroup12;
          };
          case _ {

          };
        };

        for (manager in Iter.fromArray(managers)) {
          if (manager.principalId == dto.principalId) {
            switch (manager.history) {
              case (null) {};
              case (history) {
                for (season in Iter.fromList(history)) {
                  if (season.seasonId == dto.seasonId) {
                    for (gameweek in Iter.fromList(season.gameweeks)) {
                      if (gameweek.gameweek == dto.gameweek) {
                        return ?gameweek;
                      };
                    };
                  };
                };
              };
            };

          };
        };
      };
    };
    return null;
  };

  public shared ({ caller }) func addNewManager(newManager : AppTypes.Manager) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;

    var managerBuffer = Buffer.fromArray<AppTypes.Manager>([]);
    switch (activeGroupIndex) {
      case 0 {
        managerBuffer := Buffer.fromArray(managerGroup1);
        managerBuffer.add(newManager);
        managerGroup1 := Buffer.toArray(managerBuffer);
      };
      case 1 {
        managerBuffer := Buffer.fromArray(managerGroup2);
        managerBuffer.add(newManager);
        managerGroup2 := Buffer.toArray(managerBuffer);
      };
      case 2 {
        managerBuffer := Buffer.fromArray(managerGroup3);
        managerBuffer.add(newManager);
        managerGroup3 := Buffer.toArray(managerBuffer);
      };
      case 3 {
        managerBuffer := Buffer.fromArray(managerGroup4);
        managerBuffer.add(newManager);
        managerGroup4 := Buffer.toArray(managerBuffer);
      };
      case 4 {
        managerBuffer := Buffer.fromArray(managerGroup5);
        managerBuffer.add(newManager);
        managerGroup5 := Buffer.toArray(managerBuffer);
      };
      case 5 {
        managerBuffer := Buffer.fromArray(managerGroup6);
        managerBuffer.add(newManager);
        managerGroup6 := Buffer.toArray(managerBuffer);
      };
      case 6 {
        managerBuffer := Buffer.fromArray(managerGroup7);
        managerBuffer.add(newManager);
        managerGroup7 := Buffer.toArray(managerBuffer);
      };
      case 7 {
        managerBuffer := Buffer.fromArray(managerGroup8);
        managerBuffer.add(newManager);
        managerGroup8 := Buffer.toArray(managerBuffer);
      };
      case 8 {
        managerBuffer := Buffer.fromArray(managerGroup9);
        managerBuffer.add(newManager);
        managerGroup9 := Buffer.toArray(managerBuffer);
      };
      case 9 {
        managerBuffer := Buffer.fromArray(managerGroup10);
        managerBuffer.add(newManager);
        managerGroup10 := Buffer.toArray(managerBuffer);
      };
      case 10 {
        managerBuffer := Buffer.fromArray(managerGroup11);
        managerBuffer.add(newManager);
        managerGroup11 := Buffer.toArray(managerBuffer);
      };
      case 11 {
        managerBuffer := Buffer.fromArray(managerGroup12);
        managerBuffer.add(newManager);
        managerGroup12 := Buffer.toArray(managerBuffer);
      };
      case _ {};
    };

    let managerGroupCount = managerBuffer.size();
    if (managerGroupCount > 1000) {
      activeGroupIndex := activeGroupIndex + 1;
    };
    totalManagers := totalManagers + 1;
    managerGroupIndexes.put(newManager.principalId, activeGroupIndex);
    return #ok();
  };

  public shared ({ caller }) func getTotalManagers() : async Nat {
    assert not Principal.isAnonymous(caller);
    let backendPrincipalId = Principal.toText(caller);
    assert backendPrincipalId == Environment.BACKEND_CANISTER_ID;
    return totalManagers;
  };


  system func preupgrade() {
    stable_manager_group_indexes := Iter.toArray(managerGroupIndexes.entries());
  };

  system func postupgrade() {
    let indexMap : TrieMap.TrieMap<Ids.PrincipalId, Nat8> = TrieMap.TrieMap<Ids.PrincipalId, Nat8>(Text.equal, Text.hash);

    for (link in Iter.fromArray(stable_manager_group_indexes)) {
      indexMap.put(link);
    };
    managerGroupIndexes := indexMap;
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {
  };

};
