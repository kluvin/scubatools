<script lang="ts">
  import type { ComponentType } from 'svelte';
  import { format as formatDateFns } from 'date-fns';
  // For locale-specific formatting (e.g., Norwegian), you can import the locale:
  // import { nb } from 'date-fns/locale';
  // And then use it in formatDateFns: formatDateFns(value, dateFormat, { locale: nb })

  export let value: string | Date | undefined | null = undefined; // Allow Date objects
  export let subValue: string | undefined | null = undefined;
  export let icon: ComponentType; // Added to fix linter error: 'icon' was not defined
  export let iconClass: string = 'w-5 h-5 mr-2 text-teal-600';
  export let textClass: string = 'text-lg'; // Default text class
  export let showIfValueIsNA: boolean = false; // Controls if the item shows when value is 'N/A'
  export let dateFormat: string = 'PPP'; // Default date-fns format (e.g., "MMM d, yyyy")
</script>

{#if value && (value !== 'N/A' || showIfValueIsNA)}
  <div class="flex items-center {textClass} mb-2">
    <svelte:component this={icon} class="{iconClass}" />
    <span>
      {value instanceof Date ? formatDateFns(value, dateFormat /*, { locale: nb } */) : value}
      {#if subValue && subValue !== 'N/A'}
        ({subValue})
      {/if}
    </span>
  </div>
{/if} 