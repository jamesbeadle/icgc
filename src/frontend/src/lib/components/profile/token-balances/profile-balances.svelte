<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import LoadingDots from "../../shared/global/loading-dots.svelte";
    import WithdrawbackendModal from "./withdraw-backend-modal.svelte";
    import ICGCCoinIcon from "$lib/icons/ICGCCoinIcon.svelte";

    let loadingBalances = true;
    let showWithdrawbackendModal = false;
    let backendBalance = 0n;
    let backendBalanceFormatted = "0.0000"; 

    onMount(async () => {
      await fetchBalances();
      loadingBalances = false;
    });

    async function fetchBalances() {
      backendBalance = await userStore.getbackendBalance();
      const backendBalanceInTokens = Number(backendBalance) / 100_000_000;
      backendBalanceFormatted = backendBalanceInTokens.toFixed(8);
      loadingBalances = false;
    }
  
    function loadWithdrawbackendModal(){
        showWithdrawbackendModal = true;
    };

    async function closeWithdrawbackendModal(){
        showWithdrawbackendModal = false;
        await fetchBalances();
    };
</script>
<div class="flex flex-wrap">
    <div class="w-full px-2 mb-4">
      <div class="px-2 mt-4">
        <div class="grid grid-cols-1 gap-4 md:grid-cols-4">
          <div class="flex items-center p-4 border border-gray-700 rounded-lg shadow-md">
            <ICGCCoinIcon className="h-12 w-12 md:h-9 md:w-9" />
            <div class="flex flex-col ml-4 space-y-2 md:ml-3">
                {#if loadingBalances}
                  <LoadingDots />
                {:else}
                  <p>
                    {backendBalanceFormatted} ICGC
                  </p>
                  <button class="p-1 px-2 text-sm rounded md:text-sm md:p-2 md:px-4 backend-button"
                    onclick={loadWithdrawbackendModal}
                  >
                    Withdraw
                  </button>
                {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <WithdrawbackendModal
    visible={showWithdrawbackendModal}
    closeModal={closeWithdrawbackendModal}
    cancelModal={closeWithdrawbackendModal}
    backendBalance={backendBalance}
    backendBalanceFormatted={backendBalanceFormatted}
  />