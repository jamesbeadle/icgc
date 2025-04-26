<script lang="ts">
  import { userStore } from "$lib/stores/user-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { convertToE8s, isAmountValid, isPrincipalValid } from "$lib/utils/Helpers";
  import Modal from "$lib/components/shared/global/modal.svelte";
  import LocalSpinner from "../../shared/global/local-spinner.svelte";
  
  
  interface Props {
    visible: boolean; 
    closeModal: () => void;
    cancelModal: () => void;
    backendBalance: bigint;
    backendBalanceFormatted: string;
  }
  let { visible, closeModal, cancelModal, backendBalance, backendBalanceFormatted }: Props = $props();


  let isLoading = $state(false);
  let errorMessage: string = $state("");
  let isSubmitDisabled = $state(true);
  let withdrawalAddress: string = $state("");
  let withdrawalInputAmount: string = $state("");

  function isWithdrawAmountValid(amount: string, balance: bigint): boolean {
    if (!isAmountValid(amount)) {
      return false;
    }
    
    const amountInE8s = convertToE8s(amount);
    return amountInE8s <= BigInt(balance * 100_000_000n);
  }

  function setMaxWithdrawAmount() {
    const maxAmount = Number(backendBalance) / 100_000_000;
    withdrawalInputAmount = maxAmount.toFixed(8);
  }
  
  $effect(() => {
    isSubmitDisabled = !isPrincipalValid(withdrawalAddress) || !isWithdrawAmountValid(withdrawalInputAmount, backendBalance); 
    errorMessage = (!isAmountValid(withdrawalInputAmount) || !isWithdrawAmountValid(withdrawalInputAmount, backendBalance)) && withdrawalInputAmount
    ? "Withdrawal amount greater than account balance."
    : "";
  });

  async function withdrawbackend() {
    isLoading = true;
    try {
      const amountInE8s = convertToE8s(withdrawalInputAmount);
      await userStore.withdrawbackend(withdrawalAddress, amountInE8s);
      toasts.addToast( { 
        message: "ICGC successfully withdrawn.",
        type: "success",
        duration: 2000,
      });
    } catch (error) {
      toasts.addToast({ 
        message: "Error withdrawing ICGC.",
        type: "error",
        duration: 4000,
      });
      console.error("Error withdrawing ICGC:", error);
    } finally {
      cancelModal();
      isLoading = false;
    }
  }
</script>

<Modal showModal={visible} onClose={closeModal} title="Withdraw ICGC">
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="p-4 mx-4">
      <p>ICGC Balance: {backendBalanceFormatted}</p>
      <div class="mt-4">
        <input type="text" class="backend-button" placeholder="Withdrawal Address" value={withdrawalAddress} />
      </div>
      <div class="flex items-center mt-4">
        <input type="text" class="mr-2 backend-button" placeholder="Withdrawal Amount" value={withdrawalInputAmount} />
        <button type="button" class="p-1 px-2 text-sm rounded md:text-sm md:p-2 md:px-4 backend-button" onclick={setMaxWithdrawAmount}>
          Max
        </button>
      </div>
      {#if errorMessage}
        <div class="mt-2 text-red-600">{errorMessage}</div>
      {/if}
      <div class="flex flex-row items-center py-3 space-x-4">
        <button class="px-4 py-2 default-button backend-cancel-btn" type="button"onclick={cancelModal}>
          Cancel
        </button>
        <button onclick={withdrawbackend} class={`px-4 py-2 ${ isSubmitDisabled ? "bg-gray-500" : "bg-BrandPurple"} default-button`} type="submit" disabled={isSubmitDisabled}>
          Withdraw
        </button>
      </div>
    </div>
  {/if}
</Modal>
