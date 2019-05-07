import { SpraypaintBase, attr } from 'spraypaint'

const ApplicationRecord = SpraypaintBase.extend({
  static: {
    apiNamespace: '/api/v1',
    baseUrl: window.location.origin,
  },
})

export const Course = ApplicationRecord.extend({
  static: {
    jsonapiType: 'courses',
  },
  attrs: {
    identifier: attr(),
    name: attr(),
    session: attr(),
    startsOn: attr({ type: 'dateTime' }),
    endsOn: attr({ type: 'dateTime' }),
    days: attr(),
    time: attr(),
  },
})
