import { ActorFactory } from "../utils/actor.factory";
import { isError } from "$lib/utils/Helpers";
import { authStore } from "$lib/stores/auth-store";
import type {
  CombinedProfile,
  ICGCLinkStatus,
  Result,
} from "../../../../declarations/backend/backend.did";

export class UserService {
  async getUser(): Promise<CombinedProfile | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENbackend_BACKEND_CANISTER_ID ?? "",
      );
      const result: any = await identityActor.getProfile();
      console.log("profile result in service", result);
      if (isError(result)) {
        console.error("isError fetching user profile: ", result);
        return undefined;
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching user profile: ", error);
      return undefined;
    }
  }

  async getICGCLinkStatus(): Promise<ICGCLinkStatus | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENbackend_BACKEND_CANISTER_ID ?? "",
      );
      const result: any = await identityActor.getICGCLinkStatus();
      console.log("ICGC Link Status", result);
      if (isError(result)) return undefined;
      return result.ok;
    } catch (error) {
      console.error("Error checking ICGC link status:", error);
      return undefined;
    }
  }

  async linkICGCProfile(): Promise<{
    success: boolean;
    alreadyExists?: boolean;
  }> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENbackend_BACKEND_CANISTER_ID ?? "",
      );
      const result: Result = await identityActor.linkICGCProfile();
      console.log("Link ICGC result:", result);

      if ("err" in result) {
        if ("AlreadyExists" in result.err) {
          return { success: false, alreadyExists: true };
        }
        return { success: false, alreadyExists: false };
      }

      return { success: true, alreadyExists: false };
    } catch (error) {
      console.error("Error linking ICGC profile:", error);
      return { success: false, alreadyExists: false };
    }
  }

}
