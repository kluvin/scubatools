import { format } from 'date-fns';
import { nb } from 'date-fns/locale';

export function parseDate(dateStr: string): Date | null {
  if (!dateStr || dateStr.toLowerCase() === 'dato/date') {
    return null;
  }
  const parts = dateStr.split('.');
  if (parts.length === 3) {
    // Assuming dd.mm.yy format
    const day = parseInt(parts[0], 10);
    const month = parseInt(parts[1], 10) - 1; // Month is 0-indexed
    let year = parseInt(parts[2], 10);
    if (year < 100) {
      year += 2000; // Assuming 21st century
    }
    return new Date(year, month, day);
  }
  return null;
}

export function formatDate(date: Date): string {
  const formattedDate = format(date, 'EEEE, d. MMMM', { locale: nb });
  const parts = formattedDate.split(', ');
  const dayAndMonthPart = parts[1].split('. ');
  
  const dayName = parts[0].charAt(0).toUpperCase() + parts[0].slice(1);
  const monthName = dayAndMonthPart[1].charAt(0).toUpperCase() + dayAndMonthPart[1].slice(1);
  
  return `${dayName}, ${dayAndMonthPart[0]}. ${monthName}`;
} 