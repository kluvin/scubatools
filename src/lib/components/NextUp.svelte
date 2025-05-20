<script lang="ts">
    import { CalendarDays, User, MapPin, Anchor, Users } from '@lucide/svelte';
    import '../../app.css';
    import type { Dive } from '../types';
    import { parseDate, formatDate } from '../utils';
    // Add svelte:options for custom element
    // Note: For SvelteKit library components, customElement compilation is usually configured in svelte.config.js or vite.config.js
    // However, <svelte:options> is the standard Svelte way.
    // If this doesn't work directly with `svelte-package`, we might need to adjust the build config.
  
    let upcomingDives = $state<Dive[]>([]);
    let nextDive = $state<Dive | null>(null);
    let followingDives = $state<Dive[]>([]);
  
    const csvUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ5kjuoCcs2gCVRf1b08tQQkKADD6U_drV_pjulV4gPK058SEUnLThuWvWhyIB79SzzIWQcYW20w82z/pub?output=csv';
  
    async function fetchDives() {
      try {
        const response = await fetch(csvUrl);
        const csvText = await response.text();
        const lines = csvText.split('\n').slice(1); // Skip header row
        const today = new Date();
        today.setHours(0, 0, 0, 0); // Compare dates only
  
        const dives: Dive[] = lines
          .map(line => {
            const columns = line.split(',');
            if (columns.length < 6) return null; // Ensure enough columns
  
            const rawDate = columns[1];
            const date = parseDate(rawDate);
            if (!date) return null;
  
            // Skip past dates, except if it's today
            if (date < today && date.toDateString() !== today.toDateString()) {
              return null;
            }
            // Skip entries where dive leader is "Cancelled" or "Avlyst/ Canceled" or empty
            const diveLeader = columns[2]?.trim();
            if (!diveLeader || diveLeader.toLowerCase() === 'cancelled' || diveLeader.toLowerCase() === 'avlyst/ canceled') {
              return null;
            }
  
  
            return {
              day: columns[0]?.trim() || 'N/A',
              rawDate: rawDate,
              date: date,
              diveLeader: diveLeader || 'N/A',
              mob: columns[3]?.trim() || 'N/A',
              location: columns[4]?.trim() || 'N/A',
              boatDriver: columns[5]?.trim() || 'N/A',
              helper: columns[6]?.trim() || 'N/A',
            };
          })
          .filter(dive => dive !== null) as Dive[];
  
        // Sort dives by date
        dives.sort((a, b) => a.date.getTime() - b.date.getTime());
        
        upcomingDives = dives;
  
        if (upcomingDives.length > 0) {
          nextDive = upcomingDives[0];
          followingDives = upcomingDives.slice(1, 4);
        }
  
      } catch (error) {
        console.error('Failed to fetch or parse dive data:', error);
        // Handle error appropriately in UI if necessary
      }
    }
  
    $effect(() => {
      fetchDives();
    });
  </script>
  
  {#snippet diveDetails(dive: Dive)}
    {#if dive.diveLeader !== 'N/A'}
      <div class="flex items-center mb-2">
        <User class="w-5 h-5 mr-2" />
        <span>
          {dive.diveLeader}
          {#if dive.mob !== 'N/A'}
            ({dive.mob})
          {/if}
        </span>
      </div>
    {/if}
  
    {#if dive.location && dive.location !== 'N/A'}
      <div class="flex items-center mb-2">
        <MapPin class="w-5 h-5 mr-2" />
        <span>{dive.location}</span>
      </div>
    {/if}
  
    {#if dive.boatDriver && dive.boatDriver !== 'N/A'}
      <div class="flex items-center mb-2">
        <Anchor class="w-5 h-5 mr-2" />
        <span>{dive.boatDriver}</span>
      </div>
    {/if}
  
    {#if dive.helper && dive.helper !== 'N/A'}
      <div class="flex items-center">
        <Users class="w-5 h-5 mr-2" />
        <span>{dive.helper}</span>
      </div>
    {/if}
  {/snippet}

  <div class="container mx-auto px-4 py-6 font-sans">
    {#if nextDive}
      <div class="card rounded-xl shadow-md mb-8 border border-gray-200">
        <div class="card-body p-6 md:p-8">
          <div class="flex items-center text-lg mb-2">
            <CalendarDays class="w-5 h-5 mr-2" />
            <span>
              {formatDate(nextDive.date)}
            </span>
          </div>

          {@render diveDetails(nextDive)}
        </div>
      </div>
    {:else if upcomingDives.length === 0}
      <div role="alert" class="alert alert-info border border-gray-200 p-6 rounded-lg mb-8 text-center">
        <span class="font-medium text-lg">Ingen kommende dykketurer funnet for øyeblikket.</span>
      </div>
    {/if}
  
    {#if followingDives.length > 0}
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        {#each followingDives as dive}
          <div class="card rounded-xl shadow-sm border border-gray-200  transition-shadow duration-300 ease-in-out">
            <div class="card-body p-5">
              <h4 class="card-title text-xl mb-3 flex items-center">
                <CalendarDays class="w-5 h-5 mr-2" />
                {formatDate(dive.date)}
              </h4>
              {@render diveDetails(dive)}
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </div> 