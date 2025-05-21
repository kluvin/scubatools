<script lang="ts">
  import type { ComponentType } from 'svelte';
  import { format as formatDateFns } from 'date-fns';
  // For locale-specific formatting (e.g., Norwegian), you can import the locale:
  // import { nb } from 'date-fns/locale';
  // And then use it in formatDateFns: formatDateFns(value, dateFormat, { locale: nb })

  let {
    value = undefined as string | Date | undefined | null,
    subValue = undefined as string | undefined | null,
    icon,
    iconClass = 'w-5 h-5 mr-2 text-teal-600',
    textClass = 'text-lg',
    showIfValueIsNA = false,
    dateFormat = 'PPP'
  }: {
    value?: string | Date | undefined | null;
    subValue?: string | undefined | null;
    icon: ComponentType;
    iconClass?: string;
    textClass?: string;
    showIfValueIsNA?: boolean;
    dateFormat?: string;
  } = $props();
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