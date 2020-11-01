import { writable } from 'svelte/store'

export const notifications = writable([])

export const unreadMessageCount = writable(0)
