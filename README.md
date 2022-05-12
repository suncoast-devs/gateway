# Gateway

[![Suncoast Developers Guild](https://circleci.com/gh/suncoast-devs/gateway.svg?style=shield)](https://app.circleci.com/pipelines/github/suncoast-devs/gateway)

[![Coverage Status](https://coveralls.io/repos/github/suncoast-devs/gateway/badge.svg?branch=main)](https://coveralls.io/github/suncoast-devs/gateway?branch=main)

This app manages enrollment for the Academy at Suncoast Developers Guild.

This app will be deprecated in favor of Citadel soon™.

## TODO List

- [x] Sync approve/reject for sign-offs to nutshell
- [ ] Error handling for service objects and jobs
- [ ] Tests 😬
- [x] Automate download of executed agreements
- [ ] Move Program Acceptance ownership/creation from Application to Enrollment
- [ ] Re-add tracking of visits to student status page.
- [x] Upgrade to [sentry-ruby](https://github.com/getsentry/sentry-ruby/issues/1029) when ready. Use `sentry-sidekiq`, etc.
- [ ] Should we only check email against Truemail when created or changed?
