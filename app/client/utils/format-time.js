import { DateTime } from 'luxon'

export default function formatTime(isoTime) {
  const now = DateTime.local()
  const startOfDay = now.startOf('day')
  const oneWeekAgo = now.minus({ weeks: 1 })
  const time = DateTime.fromISO(isoTime)

  if (time > startOfDay) {
    return time.toLocaleString(DateTime.TIME_SIMPLE)
  } else if (time > oneWeekAgo) {
    return time.toFormat('cccc')
  } else {
    return time.toLocaleString(DateTime.DATE_MED)
  }
}
