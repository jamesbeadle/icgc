import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/Enums";
import IcfcEnums "mo:waterway-mops/ICFCEnums";
import Management "mo:waterway-mops/Management";
import CanisterUtilities "mo:waterway-mops/CanisterUtilities";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Helpers "mo:waterway-mops/Helpers";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import Cycles "mo:base/ExperimentalCycles";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Nat16 "mo:base/Nat16";
import Bool "mo:base/Bool";
import UserQueries "../queries/user_queries";
import AppTypes "../types/app_types";
import LeaderboardQueries "../queries/leaderboard_queries";
import UserCommands "../commands/user_commands";
import PickTeamUtilities "../utilities/pick_team_utilities";
import ManagerCanister "../canister_definitions/manager-canister";
import DataCanister "canister:data_canister";
import SHA224 "mo:waterway-mops/SHA224";
import IcfcTypes "mo:waterway-mops/ICFCTypes";
import ICFCCommands "../commands/icfc_commands";
import Environment "../Environment";
import ICFCQueries "../queries/icfc_queries";

module {

  public class UserManager() {

    //stable use storage storage

    private var managerCanisterIds : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);
    private var usernames : TrieMap.TrieMap<Ids.PrincipalId, Text> = TrieMap.TrieMap<Ids.PrincipalId, Text>(Text.equal, Text.hash);
    private var uniqueManagerCanisterIds : List.List<Ids.CanisterId> = List.nil();
    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : Ids.CanisterId = "";

    private var userICFCLinks : TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICFCLink> = TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICFCLink>(Text.equal, Text.hash);

    //Getters

    public func getProfile(dto : UserQueries.GetProfile) : async Result.Result<UserQueries.Profile, Enums.Error> {
      let userManagerCanisterId = managerCanisterIds.get(dto.principalId);

      switch (userManagerCanisterId) {
        case (?foundUserCanisterId) {

          let manager_canister = actor (foundUserCanisterId) : actor {
            getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
          };
          let manager = await manager_canister.getManager(dto.principalId);

          switch (manager) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundManager) {

              let profileDTO : UserQueries.Profile = {
                principalId = dto.principalId;
                username = foundManager.username;
                termsAccepted = foundManager.termsAccepted;
                profilePicture = foundManager.profilePicture;
                profilePictureType = foundManager.profilePictureType;
                favouriteClubId = foundManager.favouriteClubId;
                createDate = foundManager.createDate;
              };
              return #ok(profileDTO);
            };
          };
        };
        case (null) {
          return #err(#NotFound);
        };
      };
    };
    public func getICFCDataHash(dto : UserQueries.GetICFCDataHash) : Result.Result<Text, Enums.Error> {
      let icfcLink : ?UserQueries.ICFCLink = userICFCLinks.get(dto.principalId);
      switch (icfcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCLink) {
          return #ok(foundICFCLink.dataHash);
        };
      };
    };

    public func getCombinedProfile(dto : UserQueries.GetProfile) : async Result.Result<UserQueries.CombinedProfile, Enums.Error> {

      let icfcProfileResult = await getICFCProfile(dto);

      switch (icfcProfileResult) {
        case (#ok(icfcProfile)) {

          let userManagerCanisterId = managerCanisterIds.get(dto.principalId);

          switch (userManagerCanisterId) {
            case (?foundUserCanisterId) {
              let manager_canister = actor (foundUserCanisterId) : actor {
                getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
              };
              let manager = await manager_canister.getManager(dto.principalId);

              switch (manager) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundManager) {
                  switch (icfcProfileResult) {
                    case (#ok icfcProfile) {
                      let profileDTO : UserQueries.CombinedProfile = {
                        principalId = dto.principalId;
                        username = icfcProfile.username;
                        termsAccepted = foundManager.termsAccepted;
                        profilePicture = icfcProfile.profilePicture;
                        profilePictureType = foundManager.profilePictureType;
                        favouriteClubId = icfcProfile.favouriteClubId;
                        createDate = foundManager.createDate;
                        favouriteLeagueId = icfcProfile.favouriteLeagueId;
                        membershipClaims = icfcProfile.membershipClaims;
                        membershipExpiryTime = icfcProfile.membershipExpiryTime;
                        membershipType = icfcProfile.membershipType;
                        nationalityId = icfcProfile.nationalityId;
                        termsAgreed = icfcProfile.termsAgreed;
                        displayName = icfcProfile.displayName;
                        createdOn = icfcProfile.createdOn;
                      };
                      return #ok(profileDTO);
                    };
                    case (#err error) {
                      return #err(error);
                    };
                  };
                };
              };

            };
            case (null) {
              let icfcLink : ?UserQueries.ICFCLink = userICFCLinks.get(dto.principalId);
              switch (icfcLink) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundICFCLink) {
                  let res = await createNewManager(foundICFCLink, icfcProfile);
                  switch (res) {
                    case (#err(error)) {
                      return #err(error);
                    };
                    case (#ok(newManager)) {
                      let profileDTO : UserQueries.CombinedProfile = {
                        principalId = dto.principalId;
                        username = icfcProfile.username;
                        termsAccepted = newManager.termsAccepted;
                        profilePicture = newManager.profilePicture;
                        profilePictureType = newManager.profilePictureType;
                        favouriteClubId = newManager.favouriteClubId;
                        createDate = newManager.createDate;
                        favouriteLeagueId = icfcProfile.favouriteLeagueId;
                        membershipClaims = icfcProfile.membershipClaims;
                        membershipExpiryTime = icfcProfile.membershipExpiryTime;
                        membershipType = icfcProfile.membershipType;
                        nationalityId = icfcProfile.nationalityId;
                        termsAgreed = icfcProfile.termsAgreed;
                        displayName = icfcProfile.displayName;
                        createdOn = icfcProfile.createdOn;
                      };
                      return #ok(profileDTO);
                    };
                  };

                };
              };

            };

          };
        };
        case (#err(error)) {
          return #err(error);
        };
      };

    };

    public func getUserICFCLinkStatus(managerPrincipalId : Ids.PrincipalId) : async Result.Result<IcfcEnums.ICFCLinkStatus, Enums.Error> {
      let icfcLink : ?UserQueries.ICFCLink = userICFCLinks.get(managerPrincipalId);

      switch (icfcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCLink) {
          return #ok(foundICFCLink.linkStatus);
        };
      };
    };

    public func getICFCProfile(dto : UserQueries.GetICFCProfile) : async Result.Result<UserQueries.ICFCProfile, Enums.Error> {
      let icfcLink : ?UserQueries.ICFCLink = userICFCLinks.get(dto.principalId);

      switch (icfcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?icfcLink) {

          let icfc_canister = actor (CanisterIds.ICFC_BACKEND_CANISTER_ID) : actor {
            getICFCProfile : UserQueries.GetICFCProfile -> async Result.Result<UserQueries.ICFCProfile, Enums.Error>;
          };

          let icfc_dto : UserQueries.GetICFCProfile = {
            principalId = icfcLink.principalId;
          };

          return await icfc_canister.getICFCProfile(icfc_dto);
        };
      };
    };

    public func getUserICFCMembership(dto : UserQueries.GetICFCMembership) : async Result.Result<IcfcEnums.MembershipType, Enums.Error> {
      let icfcLink : ?UserQueries.ICFCLink = userICFCLinks.get(dto.principalId);
      switch (icfcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCLink) {
          return #ok(foundICFCLink.membershipType);
        };
      };
    };

    public func getManagerCanisterIds() : [(Ids.PrincipalId, Ids.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    public func getUniqueManagerCanisterIds() : [Ids.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func getTotalManagers() : Result.Result<Nat, Enums.Error> {
      var count = 0;
      for (icfcLink in userICFCLinks.vals()) {
        if (icfcLink.linkStatus == #Verified) {
          count := count + 1;
        };
      };
      return #ok(count);
    };

    public func isUsernameTaken(username : Text, principalId : Text) : Bool {
      for (managerUsername in usernames.entries()) {

        let lowerCaseUsername = Helpers.toLowercase(username);
        let existingUsername = Helpers.toLowercase(managerUsername.1);

        if (lowerCaseUsername == existingUsername and managerUsername.0 != principalId) {
          return true;
        };
      };

      return false;
    };

    public func createICFCLink(dto : ICFCCommands.NotifyAppofLink) : async Result.Result<(), Enums.Error> {
      let icfcLink : AppTypes.ICFCLink = {
        principalId = dto.icfcPrincipalId;
        linkStatus = #PendingVerification;
        dataHash = await SHA224.getRandomHash();
        membershipType = dto.membershipType;
      };
      userICFCLinks.put(dto.subAppUserPrincipalId, icfcLink);
      return #ok();
    };

    public func removeICFCLink(dto : ICFCCommands.NotifyAppofRemoveLink) : async Result.Result<(), Enums.Error> {
      for (icfcLink in userICFCLinks.entries()) {
        if (icfcLink.1.principalId == dto.icfcPrincipalId) {
          let _ = userICFCLinks.remove(icfcLink.0);
          return #ok();
        };
      };
      return #err(#NotFound);
    };

    public func verifyICFCLink(dto : ICFCCommands.VerifyICFCProfile) : async Result.Result<(), Enums.Error> {
      let icfcLink : ?AppTypes.ICFCLink = userICFCLinks.get(dto.principalId);

      switch (icfcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCLink) {

          let icfc_canister = actor (Environment.ICFC_BACKEND_CANISTER_ID) : actor {
            verifySubApp : ICFCCommands.VerifySubApp -> async Result.Result<(), Enums.Error>;
          };

          let verifySubAppDTO : ICFCCommands.VerifySubApp = {
            subAppUserPrincipalId = dto.principalId;
            subApp = #GolfPad;
            icfcPrincipalId = foundICFCLink.principalId;
          };

          let result = await icfc_canister.verifySubApp(verifySubAppDTO);
          switch (result) {
            case (#ok(_)) {

              let _ = userICFCLinks.put(
                dto.principalId,
                {
                  principalId = foundICFCLink.principalId;
                  linkStatus = #Verified;
                  dataHash = await SHA224.getRandomHash();
                  membershipType = foundICFCLink.membershipType;
                },
              );

              return #ok();

            };
            case (#err error) {
              return #err(error);
            };
          };
        };
      };
    };

    public func updateFavouriteClub(dto : UserCommands.SetFavouriteClub, activeClubs : [DataCanister.Club], seasonActive : Bool) : async Result.Result<(), Enums.Error> {

      // TODO: John, This can set in a profile here and allow to be different in GolfPad from profile value

      let isClubActive = Array.find(
        activeClubs,
        func(club : DataCanister.Club) : Bool {
          return club.id == dto.favouriteClubId;
        },
      );
      if (not Option.isSome(isClubActive)) {
        return #err(#NotFound);
      };

      if (dto.favouriteClubId <= 0) {
        return #err(#InvalidData);
      };

      let managerCanisterId = managerCanisterIds.get(dto.principalId);
      switch (managerCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManagerCanisterId) {

          let manager_canister = actor (foundManagerCanisterId) : actor {
            getManager : Ids.PrincipalId -> async ?AppTypes.Manager;
            updateFavouriteClub : (dto : UserCommands.SetFavouriteClub) -> async Result.Result<(), Enums.Error>;
          };

          let manager = await manager_canister.getManager(dto.principalId);
          if (not seasonActive) {
            return await manager_canister.updateFavouriteClub(dto);
          };

          switch (manager) {
            case (?foundManager) {
              switch (foundManager.favouriteClubId) {
                case (?foundClubId) {
                  if (foundClubId > 0) {
                    return #err(#InvalidData);
                  };
                };
                case (null) {};
              };
              return await manager_canister.updateFavouriteClub(dto);
            };
            case (null) {
              return #err(#NotFound);
            };
          };
        };
      };
    };

    public func updateICFCHash(dto : ICFCCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error> {
      let icfcLink : ?AppTypes.ICFCLink = userICFCLinks.get(dto.subAppUserPrincipalId);

      switch (icfcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICFCLink) {
          let newHash = await SHA224.getRandomHash();
          let _ = userICFCLinks.put(
            dto.subAppUserPrincipalId,
            {
              principalId = foundICFCLink.principalId;
              linkStatus = foundICFCLink.linkStatus;
              dataHash = newHash;
              membershipType = dto.membershipType;
            },
          );
          return #ok();
        };
      };
    };

    public func getICFCProfileLinks() : [ICFCQueries.ICFCLinks] {
      let icfcLinks = Iter.toArray(userICFCLinks.entries());
      var result : [ICFCQueries.ICFCLinks] = [];
      for (icfcLink in Iter.fromArray(icfcLinks)) {
        let link : ICFCQueries.ICFCLinks = {
          icfcPrincipalId = icfcLink.1.principalId;
          subAppUserPrincipalId = icfcLink.0;
          membershipType = icfcLink.1.membershipType;
          subApp = #GolfPad;
        };
        result := Array.append(result, [link]);
      };
      return result;
    };

    // Temp Test function
    public func getAllUserICFCLinks() : async [(Ids.PrincipalId, AppTypes.ICFCLink)] {
      return Iter.toArray(userICFCLinks.entries());
    };

    //Private data modification functions


    private func createManagerCanister() : async Text {
      Cycles.add<system>(50_000_000_000_000);
      let canister = await ManagerCanister._ManagerCanister();
      let IC : Management.Management = actor (CanisterIds.Default);
      let _ = await CanisterUtilities.updateCanister_(canister, ?Principal.fromText(CanisterIds.GOLFPAD_BACKEND_CANISTER_ID), IC);

      let canister_principal = Principal.fromActor(canister);
      let canisterId = Principal.toText(canister_principal);

      if (canisterId == "") {
        return canisterId;
      };

      let uniqueCanisterIdBuffer = Buffer.fromArray<Ids.CanisterId>(List.toArray(uniqueManagerCanisterIds));
      uniqueCanisterIdBuffer.add(canisterId);
      uniqueManagerCanisterIds := List.fromArray(Buffer.toArray(uniqueCanisterIdBuffer));
      activeManagerCanisterId := canisterId;
      return canisterId;
    };

    //stable getters and setters

    public func getStableManagerCanisterIds() : [(Ids.PrincipalId, Ids.CanisterId)] {
      return Iter.toArray(managerCanisterIds.entries());
    };

    public func setStableManagerCanisterIds(stable_manager_canister_ids : [(Ids.PrincipalId, Ids.CanisterId)]) : () {
      let canisterIds : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);

      for (canisterId in Iter.fromArray(stable_manager_canister_ids)) {
        canisterIds.put(canisterId);
      };
      managerCanisterIds := canisterIds;
    };

    public func getStableUsernames() : [(Ids.PrincipalId, Text)] {
      return Iter.toArray(usernames.entries());
    };

    public func setStableUsernames(stable_manager_usernames : [(Ids.PrincipalId, Text)]) : () {
      let usernameMap : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);

      for (username in Iter.fromArray(stable_manager_usernames)) {
        usernameMap.put(username);
      };
      usernames := usernameMap;
    };

    public func getStableUniqueManagerCanisterIds() : [Ids.CanisterId] {
      return List.toArray(uniqueManagerCanisterIds);
    };

    public func setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids : [Ids.CanisterId]) : () {
      uniqueManagerCanisterIds := List.fromArray(stable_unique_manager_canister_ids);
    };

    public func getStableTotalManagers() : Nat {
      return totalManagers;
    };

    public func setStableTotalManagers(stable_total_managers : Nat) : () {
      totalManagers := stable_total_managers;
    };

    public func getStableActiveManagerCanisterId() : Text {
      return activeManagerCanisterId;
    };

    public func setStableActiveManagerCanisterId(stable_active_manager_canister_id : Ids.CanisterId) : () {
      activeManagerCanisterId := stable_active_manager_canister_id;
    };

    public func getStableUserICFCLinks() : [(Ids.PrincipalId, AppTypes.ICFCLink)] {
      return Iter.toArray(userICFCLinks.entries());
    };

    public func setStableUserICFCLinks(stable_user_icfc_linkss : [(Ids.PrincipalId, AppTypes.ICFCLink)]) : () {
      let linkMap : TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICFCLink> = TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICFCLink>(Text.equal, Text.hash);

      for (link in Iter.fromArray(stable_user_icfc_linkss)) {
        linkMap.put(link);
      };
      userICFCLinks := linkMap;
    };

  };

};
