import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/Enums";
import IcgcEnums "mo:waterway-mops/ICGCEnums";
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
import UserCommands "../commands/user_commands";
import SHA224 "mo:waterway-mops/SHA224";
import IcgcTypes "mo:waterway-mops/ICGCTypes";
import ICGCCommands "../commands/icgc_commands";
import Environment "../Environment";
import ICGCQueries "../queries/icgc_queries";

module {

  public class UserManager() {

    //stable use storage storage

    private var managerCanisterIds : TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId> = TrieMap.TrieMap<Ids.PrincipalId, Ids.CanisterId>(Text.equal, Text.hash);
    private var usernames : TrieMap.TrieMap<Ids.PrincipalId, Text> = TrieMap.TrieMap<Ids.PrincipalId, Text>(Text.equal, Text.hash);
    private var uniqueManagerCanisterIds : List.List<Ids.CanisterId> = List.nil();
    private var totalManagers : Nat = 0;
    private var activeManagerCanisterId : Ids.CanisterId = "";

    private var userICGCLinks : TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICGCLink> = TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICGCLink>(Text.equal, Text.hash);

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
    public func getICGCDataHash(dto : UserQueries.GetICGCDataHash) : Result.Result<Text, Enums.Error> {
      let icgcLink : ?UserQueries.ICGCLink = userICGCLinks.get(dto.principalId);
      switch (icgcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICGCLink) {
          return #ok(foundICGCLink.dataHash);
        };
      };
    };

    public func getCombinedProfile(dto : UserQueries.GetProfile) : async Result.Result<UserQueries.CombinedProfile, Enums.Error> {

      let icgcProfileResult = await getICGCProfile(dto);

      switch (icgcProfileResult) {
        case (#ok(icgcProfile)) {

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
                  switch (icgcProfileResult) {
                    case (#ok icgcProfile) {
                      let profileDTO : UserQueries.CombinedProfile = {
                        principalId = dto.principalId;
                        username = icgcProfile.username;
                        termsAccepted = foundManager.termsAccepted;
                        profilePicture = icgcProfile.profilePicture;
                        profilePictureType = foundManager.profilePictureType;
                        favouriteClubId = icgcProfile.favouriteClubId;
                        createDate = foundManager.createDate;
                        favouriteLeagueId = icgcProfile.favouriteLeagueId;
                        membershipClaims = icgcProfile.membershipClaims;
                        membershipExpiryTime = icgcProfile.membershipExpiryTime;
                        membershipType = icgcProfile.membershipType;
                        nationalityId = icgcProfile.nationalityId;
                        termsAgreed = icgcProfile.termsAgreed;
                        displayName = icgcProfile.displayName;
                        createdOn = icgcProfile.createdOn;
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
              let icgcLink : ?UserQueries.ICGCLink = userICGCLinks.get(dto.principalId);
              switch (icgcLink) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundICGCLink) {
                  let res = await createNewManager(foundICGCLink, icgcProfile);
                  switch (res) {
                    case (#err(error)) {
                      return #err(error);
                    };
                    case (#ok(newManager)) {
                      let profileDTO : UserQueries.CombinedProfile = {
                        principalId = dto.principalId;
                        username = icgcProfile.username;
                        termsAccepted = newManager.termsAccepted;
                        profilePicture = newManager.profilePicture;
                        profilePictureType = newManager.profilePictureType;
                        favouriteClubId = newManager.favouriteClubId;
                        createDate = newManager.createDate;
                        favouriteLeagueId = icgcProfile.favouriteLeagueId;
                        membershipClaims = icgcProfile.membershipClaims;
                        membershipExpiryTime = icgcProfile.membershipExpiryTime;
                        membershipType = icgcProfile.membershipType;
                        nationalityId = icgcProfile.nationalityId;
                        termsAgreed = icgcProfile.termsAgreed;
                        displayName = icgcProfile.displayName;
                        createdOn = icgcProfile.createdOn;
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

    public func getUserICGCLinkStatus(managerPrincipalId : Ids.PrincipalId) : async Result.Result<IcgcEnums.ICGCLinkStatus, Enums.Error> {
      let icgcLink : ?UserQueries.ICGCLink = userICGCLinks.get(managerPrincipalId);

      switch (icgcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICGCLink) {
          return #ok(foundICGCLink.linkStatus);
        };
      };
    };

    public func getICGCProfile(dto : UserQueries.GetICGCProfile) : async Result.Result<UserQueries.ICGCProfile, Enums.Error> {
      let icgcLink : ?UserQueries.ICGCLink = userICGCLinks.get(dto.principalId);

      switch (icgcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?icgcLink) {

          let icgc_canister = actor (CanisterIds.ICGC_BACKEND_CANISTER_ID) : actor {
            getICGCProfile : UserQueries.GetICGCProfile -> async Result.Result<UserQueries.ICGCProfile, Enums.Error>;
          };

          let icgc_dto : UserQueries.GetICGCProfile = {
            principalId = icgcLink.principalId;
          };

          return await icgc_canister.getICGCProfile(icgc_dto);
        };
      };
    };

    public func getUserICGCMembership(dto : UserQueries.GetICGCMembership) : async Result.Result<IcgcEnums.MembershipType, Enums.Error> {
      let icgcLink : ?UserQueries.ICGCLink = userICGCLinks.get(dto.principalId);
      switch (icgcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICGCLink) {
          return #ok(foundICGCLink.membershipType);
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
      for (icgcLink in userICGCLinks.vals()) {
        if (icgcLink.linkStatus == #Verified) {
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

    public func createICGCLink(dto : ICGCCommands.NotifyAppofLink) : async Result.Result<(), Enums.Error> {
      let icgcLink : AppTypes.ICGCLink = {
        principalId = dto.icgcPrincipalId;
        linkStatus = #PendingVerification;
        dataHash = await SHA224.getRandomHash();
        membershipType = dto.membershipType;
      };
      userICGCLinks.put(dto.subAppUserPrincipalId, icgcLink);
      return #ok();
    };

    public func removeICGCLink(dto : ICGCCommands.NotifyAppofRemoveLink) : async Result.Result<(), Enums.Error> {
      for (icgcLink in userICGCLinks.entries()) {
        if (icgcLink.1.principalId == dto.icgcPrincipalId) {
          let _ = userICGCLinks.remove(icgcLink.0);
          return #ok();
        };
      };
      return #err(#NotFound);
    };

    public func verifyICGCLink(dto : ICGCCommands.VerifyICGCProfile) : async Result.Result<(), Enums.Error> {
      let icgcLink : ?AppTypes.ICGCLink = userICGCLinks.get(dto.principalId);

      switch (icgcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICGCLink) {

          let icgc_canister = actor (Environment.ICGC_BACKEND_CANISTER_ID) : actor {
            verifySubApp : ICGCCommands.VerifySubApp -> async Result.Result<(), Enums.Error>;
          };

          let verifySubAppDTO : ICGCCommands.VerifySubApp = {
            subAppUserPrincipalId = dto.principalId;
            subApp = #GolfPad;
            icgcPrincipalId = foundICGCLink.principalId;
          };

          let result = await icgc_canister.verifySubApp(verifySubAppDTO);
          switch (result) {
            case (#ok(_)) {

              let _ = userICGCLinks.put(
                dto.principalId,
                {
                  principalId = foundICGCLink.principalId;
                  linkStatus = #Verified;
                  dataHash = await SHA224.getRandomHash();
                  membershipType = foundICGCLink.membershipType;
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

    public func updateICGCHash(dto : ICGCCommands.UpdateICGCProfile) : async Result.Result<(), Enums.Error> {
      let icgcLink : ?AppTypes.ICGCLink = userICGCLinks.get(dto.subAppUserPrincipalId);

      switch (icgcLink) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundICGCLink) {
          let newHash = await SHA224.getRandomHash();
          let _ = userICGCLinks.put(
            dto.subAppUserPrincipalId,
            {
              principalId = foundICGCLink.principalId;
              linkStatus = foundICGCLink.linkStatus;
              dataHash = newHash;
              membershipType = dto.membershipType;
            },
          );
          return #ok();
        };
      };
    };

    public func getICGCProfileLinks() : [ICGCQueries.ICGCLinks] {
      let icgcLinks = Iter.toArray(userICGCLinks.entries());
      var result : [ICGCQueries.ICGCLinks] = [];
      for (icgcLink in Iter.fromArray(icgcLinks)) {
        let link : ICGCQueries.ICGCLinks = {
          icgcPrincipalId = icgcLink.1.principalId;
          subAppUserPrincipalId = icgcLink.0;
          membershipType = icgcLink.1.membershipType;
          subApp = #GolfPad;
        };
        result := Array.append(result, [link]);
      };
      return result;
    };

    // Temp Test function
    public func getAllUserICGCLinks() : async [(Ids.PrincipalId, AppTypes.ICGCLink)] {
      return Iter.toArray(userICGCLinks.entries());
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

    public func getStableUserICGCLinks() : [(Ids.PrincipalId, AppTypes.ICGCLink)] {
      return Iter.toArray(userICGCLinks.entries());
    };

    public func setStableUserICGCLinks(stable_user_icgc_linkss : [(Ids.PrincipalId, AppTypes.ICGCLink)]) : () {
      let linkMap : TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICGCLink> = TrieMap.TrieMap<Ids.PrincipalId, AppTypes.ICGCLink>(Text.equal, Text.hash);

      for (link in Iter.fromArray(stable_user_icgc_linkss)) {
        linkMap.put(link);
      };
      userICGCLinks := linkMap;
    };

  };

};
