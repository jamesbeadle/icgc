/* ----- Mops Packages ----- */
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";

import Account "mo:waterway-mops/base/def/account";
import BaseTypes "mo:waterway-mops/base/types";
import BaseQueries "mo:waterway-mops/base/queries";
import CanisterCommands "mo:waterway-mops/product/wwl/canister-management/commands";
import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import CanisterManager "mo:waterway-mops/product/wwl/canister-management/manager";
import CanisterQueries "mo:waterway-mops/product/wwl/canister-management/queries";
import CanisterUtilities "mo:waterway-mops/product/wwl/canister-management/utilities";
import Countries "mo:waterway-mops/base/countries";
import Enums "mo:waterway-mops/base/enums";
import SNSToken "mo:waterway-mops/base/def/sns-wrappers/ledger";
import Ids "mo:waterway-mops/base/ids";
import Management "mo:waterway-mops/base/def/management";

/* ----- Canister Definition Files ----- */

import ProfileCanister "canister_definitions/profile-canister";

/* ----- Queries ----- */
import AppQueries "queries/app-queries";
import ProfileQueries "queries/profile-queries";
import PayoutQueries "queries/payout-queries";

/* ----- Commands ----- */
import ProfileCommands "commands/profile-commands";
import PayoutCommands "commands/payout-commands";

/* ----- Managers ----- */

import ProfileManager "managers/profile-manager";

/* ----- Environment ----- */
import Environment "environment";

actor class Self() = this {

  /* ----- Stable Canister Variables ----- */
  private stable var stable_profile_canister_index : [(Ids.PrincipalId, Ids.CanisterId)] = [];
  private stable var stable_active_profile_canister_id : Ids.CanisterId = "";
  private stable var stable_usernames : [(Ids.PrincipalId, Text)] = [];
  private stable var stable_unique_profile_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_total_profile : Nat = 0;
  private stable var stable_neurons_used_for_membership : [(Blob, Ids.PrincipalId)] = [];

  private stable var stable_leaderboard_payout_requests : [ICGCTypes.PayoutRequest] = [];

  private stable var stable_membership_timer_id : Nat = 0;

  /* ----- Domain Object Managers ----- */
  private let profileManager = ProfileManager.ProfileManager();
  private let snsManager = SNSManager.SNSManager();
  private let canisterManager = CanisterManager.CanisterManager();
  private let leaderboardPayoutManager = LeaderboardPayoutManager.LeaderboardPayoutManager();

  private var appStatus : BaseTypes.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  public shared query func getAppStatus() : async Result.Result<AppQueries.AppStatus, Enums.Error> {
    return #ok(appStatus);
  };

  //Profile Queries

  public shared ({ caller }) func getProfile() : async Result.Result<ProfileQueries.ProfileDTO, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : ProfileQueries.GetProfile = {
      principalId = Principal.toText(caller);
    };
    return await profileManager.getProfile(dto);
  };

  public shared query ({ caller }) func isUsernameValid(dto : ProfileQueries.IsUsernameValid) : async Bool {
    assert not Principal.isAnonymous(caller);
    let usernameValid = Utilities.isUsernameValid(dto.username);
    let usernameTaken = profileManager.isUsernameTaken(dto.username, Principal.toText(caller));
    return usernameValid and not usernameTaken;
  };

  public shared ({ caller }) func getUserNeurons() : async Result.Result<ProfileQueries.UserNeuronsDTO, Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let neurons = await snsManager.getUsersNeurons(caller);
    let userEligibility : ProfileQueries.EligibleMembership = Utilities.getMembershipType(neurons);
    let isValidNeurons = profileManager.validNeurons(userEligibility.eligibleNeuronIds, Principal.toText(caller));

    if (not isValidNeurons) {
      let dto : ProfileQueries.UserNeuronsDTO = {
        userNeurons = [];
        totalMaxStaked = 0;
        userMembershipEligibility = {
          membershipType = #NotEligible;
          eligibleNeuronIds = [];
        };
      };
      return #ok(dto);
    };

    let totalMaxStaked = Utilities.getTotalMaxStaked(neurons);
    let result : ProfileQueries.UserNeuronsDTO = {
      userNeurons = neurons;
      totalMaxStaked;
      userMembershipEligibility = userEligibility;
    };
    return #ok(result);

  };

  //Profile Commands

  public shared ({ caller }) func createProfile(dto : ProfileCommands.CreateProfile) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);

    let neurons = await snsManager.getUsersNeurons(caller);
    let userEligibility : ProfileCommands.EligibleMembership = Utilities.getMembershipType(neurons);

    return await profileManager.createProfile(principalId, dto, userEligibility);
  };

  public shared ({ caller }) func claimMembership() : async Result.Result<(ProfileCommands.MembershipClaim), Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let principalId = Principal.toText(caller);
    return await profileManager.claimMembership(principalId);
  };

  public shared ({ caller }) func addSubApp(dto : ProfileCommands.AddSubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await profileManager.addSubApp(Principal.toText(caller), dto);
  };

  public shared ({ caller }) func removeSubApp(subApp : ProfileCommands.SubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await profileManager.removeSubApp(Principal.toText(caller), subApp);
  };

  public shared ({ caller }) func verifySubApp(dto : ProfileCommands.VerifySubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Utilities.isSubApp(Principal.toText(caller));
    return await profileManager.verifySubApp(dto);
  };

  public shared ({ caller }) func updateUsername(dto : ProfileCommands.UpdateUserName) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateUsername(principalId, dto);
  };

  public shared ({ caller }) func updateDisplayName(dto : ProfileCommands.UpdateDisplayName) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateDisplayName(principalId, dto);
  };

  public shared ({ caller }) func updateNationality(dto : ProfileCommands.UpdateNationality) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateNationality(principalId, dto);
  };

  public shared ({ caller }) func updateFavouriteClub(dto : ProfileCommands.UpdateFavouriteClub) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateFavouriteClub(principalId, dto);
  };

  public shared ({ caller }) func updateProfilePicture(dto : ProfileCommands.UpdateProfilePicture) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateProfilePicture(principalId, dto);
  };

  public shared ({ caller }) func getTokenBalances() : async Result.Result<AppQueries.TokenBalances, Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let icgc_ledger : SNSToken.Interface = actor (CanisterIds.ICGC_SNS_LEDGER_CANISTER_ID);
    let ckBTC_ledger : SNSToken.Interface = actor (Environment.CKBTC_LEDGER_CANISTER_ID);
    let icp_ledger : SNSToken.Interface = actor (CanisterIds.NNS_LEDGER_CANISTER_ID);

    let icgc_tokens = await icgc_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICGC_BACKEND_CANISTER_ID);
      subaccount = null;
    });
    let ckBTC_tokens = await ckBTC_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICGC_BACKEND_CANISTER_ID);
      subaccount = null;
    });
    let icp_tokens = await icp_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICGC_BACKEND_CANISTER_ID);
      subaccount = null;
    });

    return #ok({
      ckBTCBalance = ckBTC_tokens;
      icgcBalance = icgc_tokens;
      icpBalance = icp_tokens;
      icgcBalance = 0; // TODO after ICGC SNS
    });
  };

  public shared ({ caller }) func getICGCProfile(dto : ProfileCommands.GetICGCProfile) : async Result.Result<ProfileQueries.ProfileDTO, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Utilities.isSubApp(Principal.toText(caller));
    return await profileManager.getProfile(dto);
  };

  public shared ({ caller }) func getICGCProfileSummary(dto : ProfileCommands.GetICGCProfile) : async Result.Result<ProfileQueries.ICGCProfileSummary, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Utilities.isSubApp(Principal.toText(caller));
    return await profileManager.getICGCProfileSummary(dto);
  };



  /* ----- Golf Course Queries and Commands ----- */

  public shared query ({ caller }) func getGolfCourse(dto : GolfCourseQueries.GetGolfCourse) : async Result.Result<GolfCourseQueries.GolfCourse, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return golfCourseManager.getGolfCourse(dto);
  };

  public shared query ({ caller }) func listGolfCourses(dto : GolfCourseQueries.ListGolfCourses) : async Result.Result<GolfCourseQueries.GolfCourses, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return golfCourseManager.listGolfCourses(dto);
  };

  public shared ({ caller }) func createGolfCourse(dto : GolfCourseCommands.CreateGolfCourse) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await isAdmin(principalId);
    return golfCourseManager.createGolfCourse(dto);
  };

  public shared ({ caller }) func updateGolfCourse(dto : GolfCourseCommands.UpdateGolfCourse) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await isAdmin(principalId);
    return golfCourseManager.updateGolfCourse(dto);
  };

  /* ----- Golfer Queries and Commands ----- */

  public shared query ({ caller }) func getGolfer(dto : GolferQueries.GetGolfer) : async Result.Result<GolferQueries.Golfer, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return golferManager.getGolfer(dto);
  };

  public shared query ({ caller }) func listGolfers(dto : GolferQueries.ListGolfers) : async Result.Result<GolferQueries.Golfers, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return golferManager.listGolfers(dto);
  };

  public shared ({ caller }) func createGolfer(dto : GolferCommands.CreateGolfer) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await isAdmin(principalId);
    return golferManager.createGolfer(dto);
  };

  public shared ({ caller }) func updateGolfer(dto : GolferCommands.UpdateGolfer) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await isAdmin(principalId);
    return golferManager.updateGolfer(dto);
  };



  /* ----- Tournament Queries and Commands ----- */

  public shared query ({ caller }) func getTournament(dto : TournamentQueries.GetTournament) : async Result.Result<TournamentQueries.Tournament, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return tournamentManager.getTournament(dto);
  };

  public shared query ({ caller }) func getTournamentInstance(dto: TournamentQueries.GetTournamentInstance) : async Result.Result<TournamentQueries.TournamentInstance, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return tournamentManager.getTournamentInstance(dto);
  };

  public shared query ({ caller }) func listTournaments(dto : TournamentQueries.ListTournaments) : async Result.Result<TournamentQueries.Tournaments, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return tournamentManager.listTournaments(dto);
  };

  public shared ({ caller }) func createTournament(dto : TournamentCommands.CreateTournament) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await isAdmin(principalId);
    return tournamentManager.createTournament(dto);
  };

  public shared ({ caller }) func updateTournamentStage(dto : TournamentCommands.UpdateTournamentStage) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await isAdmin(principalId);
    return tournamentManager.updateTournamentStage(dto);
  };

  public shared ({ caller }) func calculateLeaderboard(dto : FantasyLeaderboardCommands.CalculateLeaderboard) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await isAdmin(principalId);

    let tournament = tournamentManager.getTournamentInstance({
      tournamentId = dto.tournamentId;
      year = dto.year;
    });

    switch (tournament) {
      case (#ok foundTournament) {

        let golfCourse = golfCourseManager.getGolfCourse({
          golfCourseId = foundTournament.golfCourseId;
        });
        switch (golfCourse) {
          case (#ok foundGolfCourse) {
            userManager.calculateScorecards(foundTournament.leaderboard, foundGolfCourse);
            if (not foundTournament.populated) {
              transferLeaderboardChunks(dto.tournamentId, dto.year, foundGolfCourse);
            };

            fantasyLeaderboardManager.calculateLeaderboard(dto.tournamentId, dto.year);
            return #ok();
          };
          case (_) {
            return #err(#NotFound);
          };
        };

      };
      case (_) {
        return #err(#NotFound);
      };
    };
  };



  private func validateUsernameFormat(username : Text) : Bool {
    if (Text.size(username) < 3 or Text.size(username) > 20) {
      return false;
    };

    let isAlphanumeric = func(s : Text) : Bool {
      let chars = Text.toIter(s);
      for (c in chars) {
        if (not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or (c == ' '))) {
          return false;
        };
      };
      return true;
    };

    if (not isAlphanumeric(username)) {
      return false;
    };
    return true;
  };

  /* ----- Calls to Data Canister ----- */

  public shared ({ caller }) func getCountries(dto : BaseQueries.GetCountries) : async Result.Result<BaseQueries.Countries, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return #ok({
      countries = Countries.countries;
    });
  };

  public shared ({ caller }) func getLeagues(dto : LeagueQueries.GetLeagues) : async Result.Result<LeagueQueries.Leagues, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // TODO: Check caller is a member

    let data_canister = actor (CanisterIds.ICGC_DATA_CANISTER_ID) : actor {
      getLeagues : (dto : LeagueQueries.GetLeagues) -> async Result.Result<LeagueQueries.Leagues, Enums.Error>;
    };
    let result = await data_canister.getLeagues(dto);
    return result;
  };

  /* ----- Calls from Applications requesting leaderboard payout ----- */

  public shared ({ caller }) func requestLeaderboardPayout(dto : LeaderboardPayoutCommands.LeaderboardPayoutRequest) : async Result.Result<(), Enums.Error> {

    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert Utilities.isValidCanisterId(principalId);

    let res = await leaderboardPayoutManager.addLeaderboardPayoutRequest(dto);
    return res;

  };

  public shared ({ caller }) func getLeaderboardRequests(_ : PayoutQueries.GetLeaderboardRequests) : async Result.Result<PayoutQueries.LeaderboardRequests, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await Utilities.isDeveloperNeuron(principalId);
    let result = leaderboardPayoutManager.getLeaderboardPayoutRequests();
    return #ok({
      requests = result;
      totalRequest = Array.size(result);
    });

  };

  public shared ({ caller }) func payoutLeaderboard(dto : PayoutCommands.PayoutLeaderboard) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await Utilities.isDeveloperNeuron(principalId);

    let appCanisterId = Utilities.getAppCanisterId(dto.app);
    switch (appCanisterId) {
      case (?canisterId) {
        let res = await leaderboardPayoutManager.payoutLeaderboard(dto);
        switch (res) {

          case (#ok(paidRequest)) {
            var callbackCanister = actor (canisterId) : actor {
              leaderboardPaid : (dto : LeaderboardPayoutCommands.CompleteLeaderboardPayout) -> async Result.Result<(), Enums.Error>;
            };
            await callbackCanister.leaderboardPaid({
              seasonId = paidRequest.seasonId;
              gameweek = paidRequest.gameweek;
              totalEntries = paidRequest.totalEntries;
              totalPaid = paidRequest.totalPaid;
              leaderboard = paidRequest.leaderboard;
            });
          };
          case (#err(err)) {
            return #err(err);
          };

        };

      };
      case (_) {
        return #err(#NotAllowed);
      };
    };

  };

  /* ----- Calls for Debug ----- */
  public shared ({ caller }) func getProfileCanisterIds() : async [Ids.CanisterId] {
    assert not Principal.isAnonymous(caller);
    return profileManager.getStableUniqueCanisterIds();
  };
  public shared ({ caller }) func getProfileCanisterIndex() : async [(Ids.PrincipalId, Ids.CanisterId)] {
    assert not Principal.isAnonymous(caller);
    return profileManager.getStableCanisterIndex();
  };

  public shared ({ caller }) func getClubs(dto : ClubQueries.GetClubs) : async Result.Result<ClubQueries.Clubs, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // TODO: Check caller is a member

    let data_canister = actor (CanisterIds.ICGC_DATA_CANISTER_ID) : actor {
      getClubs : (dto : ClubQueries.GetClubs) -> async Result.Result<ClubQueries.Clubs, Enums.Error>;
    };
    return await data_canister.getClubs(dto);
  };

  //System Backup and Upgrade Functions:

  system func preupgrade() {
    backupProfileData();
    backupLeaderboardPayoutRequests();

    // stop membership timer
    if (stable_membership_timer_id != 0) {
      Timer.cancelTimer(stable_membership_timer_id);
    };
  };

  system func postupgrade() {
    setProfileData();
    setLeaderboardPayoutRequests();

    stable_golfers := golferManager.getStableGolfers();
    stable_golf_courses := golfCourseManager.getStableGolfCourses();

    stable_tournaments := tournamentManager.getStableTournaments();


    userManager.setStableProfiles(stable_profiles);
    userManager.setStablePredictions(stable_predictions);
    golferManager.setStableGolfers(stable_golfers);
    golfCourseManager.setStableGolfCourses(stable_golf_courses);
    fantasyLeaderboardManager.setStableLeaderboards(stable_fantasy_leaderboards);
    tournamentManager.setStableTournaments(stable_tournaments);
    stable_membership_timer_id := Timer.recurringTimer<system>(#seconds(86_400), checkMembership);
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  public shared func getCanisterIds() : async [Ids.CanisterId] {
    return profileManager.getStableUniqueCanisterIds();
  };

  private func postUpgradeCallback() : async () {
    // await updateProfileCanisterWasms();

    // let currentProfileCanisterIds = ["cjcdx-oyaaa-aaaal-qsl4q-cai"];
    // stable_unique_profile_canister_ids := currentProfileCanisterIds;
    // profileManager.setStableUniqueCanisterIds(stable_unique_profile_canister_ids);

  };

  private func backupLeaderboardPayoutRequests() {
    stable_leaderboard_payout_requests := leaderboardPayoutManager.getStableLeaderboardPayoutRequests();
  };
  private func setLeaderboardPayoutRequests() {
    leaderboardPayoutManager.setStableLeaderboardPayoutRequests(stable_leaderboard_payout_requests);
  };

  private func backupProfileData() {
    stable_profile_canister_index := profileManager.getStableCanisterIndex();
    stable_active_profile_canister_id := profileManager.getStableActiveCanisterId();
    stable_usernames := profileManager.getStableUsernames();
    stable_unique_profile_canister_ids := profileManager.getStableUniqueCanisterIds();
    stable_total_profile := profileManager.getStableTotalProfiles();
    stable_neurons_used_for_membership := profileManager.getStableNeuronsUsedforMembership();
  };

  private func setProfileData() {
    profileManager.setStableCanisterIndex(stable_profile_canister_index);
    profileManager.setStableActiveCanisterId(stable_active_profile_canister_id);
    profileManager.setStableUsernames(stable_usernames);
    profileManager.setStableUniqueCanisterIds(stable_unique_profile_canister_ids);
    profileManager.setStableTotalProfiles(stable_total_profile);
    profileManager.setStableNeuronsUsedforMembership(stable_neurons_used_for_membership);
  };

  private func updateProfileCanisterWasms() : async () {
    let profileCanisterIds = profileManager.getStableUniqueCanisterIds();
    let IC : Management.Management = actor (CanisterIds.Default);
    for (canisterId in Iter.fromArray(profileCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldCanister = actor (canisterId) : actor {};
      let _ = await (system ProfileCanister._ProfileCanister)(#upgrade oldCanister)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  private func reinstallProfileCanisterWasms() : async () {
    let profileCanisterIds = profileManager.getStableUniqueCanisterIds();
    let IC : Management.Management = actor (CanisterIds.Default);
    for (canisterId in Iter.fromArray(profileCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldCanister = actor (canisterId) : actor {};
      let _ = await (system ProfileCanister._ProfileCanister)(#reinstall oldCanister)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  // callbacks for profile_canister
  public shared ({ caller }) func removeNeuronsforExpiredMembership(pofile_principal : Ids.PrincipalId) : async () {
    assert profileManager.isProfileCanister(Principal.toText(caller));
    await profileManager.removeNeuronsforExpiredMembership(pofile_principal);
  };

  private func checkMembership() : async () {
    await profileManager.checkMemberships();
  };

  //functions for WWL backend to communicate
  public shared ({ caller }) func getProjectCanisters() : async Result.Result<CanisterQueries.ProjectCanisters, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;

    var projectCanisters : [CanisterQueries.Canister] = [];

    // profile canisters
    let profileCanisterIds = profileManager.getStableUniqueCanisterIds();
    for (canisterId in Iter.fromArray(profileCanisterIds)) {
      let dto : CanisterQueries.Canister = {
        app = #ICGC;
        canisterId = canisterId;
        canisterType = #Dynamic;
        canisterName = "Profile Canister";
      };
      projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [dto]);

    };

    // backend canister
    var backend_dto : CanisterQueries.Canister = {
      canisterId = CanisterIds.ICGC_BACKEND_CANISTER_ID;
      canisterType = #Static;
      canisterName = "ICGC Backend Canister";
      app = #ICGC;
    };
    projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [backend_dto]);

    // frontend canister
    let frontend_dto : CanisterQueries.Canister = {
      canisterId = Environment.ICGC_FRONTEND_CANISTER_ID;
      canisterType = #Static;
      canisterName = "ICGC Frontend Canister";
      app = #ICGC;
    };

    projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [frontend_dto]);

    let result3 = await saleCanister.getCanisterInfo();
    switch (result3) {
      case (#ok(canisterInfo)) {
        projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [canisterInfo]);
      };
      case (#err(_)) {};
    };

    let res : CanisterQueries.ProjectCanisters = {
      entries = projectCanisters;
    };
    return #ok(res);
  };

  public shared ({ caller }) func addController(dto : CanisterCommands.AddController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.addController(dto);
    return result;
  };
  public shared ({ caller }) func removeController(dto : CanisterCommands.RemoveController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.removeController(dto);
    return result;
  };

  public shared ({ caller }) func transferCycles(dto : CanisterCommands.TopupCanister) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.topupCanister(dto);
    switch (result) {
      case (#ok()) {
        return #ok(());
      };
      case (#err(err)) {
        return #err(err);
      };
    };

  };

  public shared ({ caller }) func getAppicationLogs(dto : CanisterQueries.GetApplicationLogs) : async Result.Result<CanisterQueries.ApplicationLogs, Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;

    var logs : [CanisterQueries.SystemEvent] = [];

    let canisterLogsResult = await canisterManager.getCanisterLogs({
      app = dto.app;
      canisterId = CanisterIds.ICGC_BACKEND_CANISTER_ID;
    });

    // let #ok(canisterLogs) = canisterLogsResult else {
    //   return canisterLogsResult;
    // };

    switch (canisterLogsResult) {

      case (#err(err)) {
        return #err(err);
      };
      case (#ok(canisterLogs)) {
        let log_records = canisterLogs.canister_log_records;
        for (log_record in Iter.fromArray(log_records)) {
          var logText = Text.decodeUtf8(log_record.content);

          let log : CanisterQueries.SystemEvent = {
            eventId = Nat64.toNat(log_record.idx);
            eventTime = Nat64.toNat(log_record.timestamp_nanos);
            eventType = #Information;
            eventTitle = "Canister Log";
            eventDetail = Option.get(logText, "Unknown");
          };
          logs := Array.append<CanisterQueries.SystemEvent>(logs, [log]);
        };

        let result : CanisterQueries.ApplicationLogs = {
          app = dto.app;
          logs = logs;
          totalEntries = Array.size(logs);
        };
        return #ok(result);

      };
    };

  };

};
