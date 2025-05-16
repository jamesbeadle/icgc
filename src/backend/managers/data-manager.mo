import Result "mo:base/Result";
import CanisterIds "mo:waterway-mops/product/wwl/CanisterIds";
import Enums "mo:waterway-mops/base/Enums";
import DataCanister "canister:data_canister";

module {

  public class DataManager() {

    public func getGolfCourse(dto : DataCanister.GetGolfCourse) : async Result.Result<DataCanister.GolfCourse, Enums.Error> {
     let data_canister = actor (CanisterIds.ICGCC_DATA_CANISTER_ID) : actor {
        getGolfCourse : shared (dto : DataCanister.GetGolfCourse) -> async Result.Result<DataCanister.Seasons, Enums.Error>;
      };
      return await data_canister.getGolfCourse(dto);
    };

    public func getProGolfer(dto : DataCanister.GetProGolfer) : async Result.Result<DataCanister.ProGolfer, Enums.Error> {
      let data_canister = actor (CanisterIds.ICGC_DATA_CANISTER_ID) : actor {
        getProGolfer : shared (dto : DataCanister.GetProGolfer) -> async Result.Result<DataCanister.ProGolfer, Enums.Error>;
      };
      return await data_canister.getProGolfer(dto);
    };

  };

};
