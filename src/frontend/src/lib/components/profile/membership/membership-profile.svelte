<script lang="ts">
  import FullScreenSpinner from "../../shared/global/full-screen-spinner.svelte";
  import CopyPrincipal from "../details/copy-principal.svelte";
  import MembershipLinkedModal from "./membership-linked-modal.svelte";
  import { toasts } from "$lib/stores/toasts-store";
  import { userStore } from "$lib/stores/user-store";
  import { authStore } from "$lib/stores/auth-store";
  import { get } from "svelte/store";
  import { userIdCreatedStore } from "$lib/stores/user-control-store";
  import { onMount } from "svelte";

  let isLoading = $state(false);

  let membershipLinked = $state(false);
  let notLinked = $state(true);
  let loadingMessage = $state("");

  onMount(async () => {
    await checkMembership();
  });

  async function checkMembership(){
    loadingMessage = "Checking ICGC Link Status";
    await checkICGCLinkStatus();
  }

  async function checkICGCLinkStatus(){
    isLoading = true;
    try {
      const principalId = get(authStore).identity?.getPrincipal().toString();
      if (!principalId) return;
      
      const icgcLinkStatus = await userStore.getICGCLinkStatus();
      console.log('icgcLinkStatus', icgcLinkStatus);
      if (icgcLinkStatus) {
        if ('PendingVerification' in icgcLinkStatus) {
          notLinked = false;
          toasts.addToast({
            type: "info",
            message: "ICGC Membership Pending Verification",
            duration: 4000,
          });
        } else if ('Verified' in icgcLinkStatus) {
          membershipLinked = true;
          notLinked = false;
          toasts.addToast({
            type: "success",
            message: "ICGC Membership Linked",
            duration: 4000,
          })
          userIdCreatedStore.set({ data: principalId, certified: true });
          //window.location.href = "/";
        } 
      } else {
            notLinked = true;
            toasts.addToast({
              type: "error",
              message: "Please Start ICGC Membership Link Process",
              duration: 4000,
          })
      }
    } catch (error) {
      console.error("Error checking ICGC link status:", error);
      toasts.addToast({
        type: "error",
        message: "Error Checking ICGC Link Status",
        duration: 4000,
      });
    } finally {
      isLoading = false;
    }
  }

  async function handleLinkICGCProfile(){
    try {
      isLoading = true;
      loadingMessage = "Linking ICGC Membership";
      const result = await userStore.linkICGCProfile();
      console.log('Link result:', result);
      
      if (result.success) {
        const principalId = get(authStore).identity?.getPrincipal().toString();
        if (!principalId) return;
        userIdCreatedStore.set({ data: principalId, certified: true });
        toasts.addToast({
          type: "success",
          message: "ICGC Membership Linked",
          duration: 5000,
        });
        window.location.href = "/";
      } else if (result.alreadyExists) {
        toasts.addToast({
          type: "info",
          message: "This Principal ID is already linked to an ICGC Membership",
          duration: 4000,
        });
        loadingMessage = "Re-checking ICGC Link Status";
        await checkMembership();
      } else {
        toasts.addToast({
          type: "error",
          message: "Failed to link ICGC Membership",
          duration: 5000,
        });
      }
    } catch (error) {
      console.error("Error linking ICGC Membership:", error);
      toasts.addToast({
        type: "error",
        message: "Failed to link ICGC Membership",
        duration: 5000,
      });
    } finally {
      isLoading = false;
    }
  } 
</script>

{#if isLoading}
<FullScreenSpinner message={loadingMessage} />
{:else}
<div class="flex flex-col w-full h-full mx-auto">
  <div class="flex-1 w-full p-6 mx-auto">
    <div class="p-8 rounded-lg shadow-xl bg-gray-900/50">
      <div class="mb-8 border-b border-BrandGreen">
        <h1 class="mb-2 text-4xl font-bold text-white">ICGC Membership Profile</h1>
      </div>
      <div class="space-y-6 text-gray-300">
        <p class="text-lg">
          Openbackend is free to play for ICGC owners who have claimed their membership through 
          <a 
            href="https://icgc.app/membership" 
            target="_blank" 
            class="underline transition-colors text-BrandGreen hover:text-BrandGreen/80"
          >
            icgc.app
          </a>.
        </p>
        <p class="mb-4 text-lg">
          Please link your Openbackend principal ID within your ICGC profile to play and then click the button below to refresh your status.
        </p>
        <div class="mb-6">
          <CopyPrincipal  bgColor="gray" borderColor="white"/>
        </div>
        {#if !notLinked}
          <p class="px-2 mb-4 text-lg text-BrandGreen">
            Your ICGC membership is pending verification. Please click the button below to finalize the linking process.
          </p>
        {/if}
        <div class="flex justify-center pt-4">
          {#if notLinked}
            <button 
              class="backend-button default-button hover:bg-BrandGreen/80"
              onclick={checkMembership}
            >
              <span>Refresh Status</span>
            </button>
          {:else}
            <button 
              class="backend-button default-button "
              onclick={handleLinkICGCProfile}
            >
              <span>Link ICGC Membership</span>
            </button>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>
{/if}

{#if membershipLinked}
  <MembershipLinkedModal visible={membershipLinked} />
{/if}