/* ----- Mops Packages ----- */

import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Int "mo:base/Int";
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
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import TrieMap "mo:base/TrieMap";

/* ----- WWL Mops Packages ----- */





/* ----- Queries ----- */


/* ----- Commands ----- */

import ProGolferCommands "commands/pro-golfer-commands";
import GolfCourseCommands "commands/golf-course-commands";
import TournamentCommands "commands/golf-tournament-commands";

import Environment "environment";
import AppQueries "queries/app-queries";
import NotificationManager "managers/notification-manager";


actor Self {

  /* ----- Stable Canister Variables ----- */

  private stable var tournaments : [GolfTypes.Tournament] = [];
  private stable var pro_golfers : [GolfTypes.ProGolfer] = [];
  private stable var golf_courses : [GolfTypes.GolfCourse] = [];
  private stable var dataHashes : [BaseTypes.DataHash] = [];
  private stable var dataTotals : SummaryTypes.DataTotals = {
    totalTournaments = 0;
    totalProGolfers = 0;
    totalGolfCourses = 0;
  };

  /* ----- Managers ----- */

  private let notificationManager = NotificationManager.NotificationManager();
  private let canisterManager = CanisterManager.CanisterManager();
  private let logsManager = LogsManager.LogsManager();

  /* ----- General App Queries ----- */

  public shared query ({ caller }) func getDataHashes(dto : AppQueries.GetDataHashes) : async Result.Result<AppQueries.DataHashes, Enums.Error> {
    assert callerAllowed(caller);
    return #ok(dataHashes);
  };


  /* ----- Private Queries ------ */

  private func callerAllowed(caller : Principal) : Bool {
    let foundCaller = Array.find<Ids.PrincipalId>(
      Environment.APPROVED_CANISTERS,
      func(canisterId : Ids.CanisterId) : Bool {
        Principal.toText(caller) == canisterId;
      },
    );
    return Option.isSome(foundCaller);
  };

  /* ----- Private Commands ------ */

  private func updateDataHash(category : Text) : async () {
    let randomHash = await SHA224.getRandomHash();

    for (hashObj in Iter.fromArray(entry.1)) {
      if (hashObj.category == category) {
        hashBuffer.add({ category = hashObj.category; hash = randomHash });
        updated := true;
      } else { hashBuffer.add(hashObj) };
    };
  };

  

  /* ----- Canister Lifecycle Functions ----- */

  system func preupgrade() {};

  system func postupgrade() {
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {
  };

  /* ----- WWL Canister Management Functions ----- */
  public shared ({ caller }) func getCanisterInfo() : async Result.Result<CanisterQueries.Canister, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : CanisterQueries.Canister = {
      canisterId = CanisterIds.ICGC_DATA_CANISTER_ID;
      canisterName = "ICGC Data Canister";
      canisterType = #Static;
      app = #GolfPad;
    };
    return #ok(dto);
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

};
