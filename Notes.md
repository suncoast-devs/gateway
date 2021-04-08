# Event Sourcing / CQRS

## Structure

- `app/commands`
- `app/domain`
- `app/events`
- `app/projections`
- `app/queries`
- `app/sagas`
- `lib/event_bus.rb`
- `lib/command_bus.rb`

# Considerations

- All GET requests are queries
- All POST requests are commands
  - Commands respond with nothing (202 ACCEPTED) on success, or validation errors
- Commands represent intent, and are named as actions, e.g. "CreateCohortCommand"
- Events are "facts", names are past tense, e.g. "CohortCreatedEvent"

## CQRS + REST

- Controller names represent aggregate names (for commands) or projection names (for queries)

Example Mappings:

    GET  /cohorts          -> Query::Cohort::Collection
    GET  /cohorts/1        -> Query::Cohort::Member
    GET  /cohorts/new      -> New UUID for Cohort Aggregate
    POST /cohorts          -> Command::Cohort::Create
    POST /cohorts/1        -> Command::Cohort::Update
    POST /cohorts/1/delete -> Command::Cohort::Delete
    POST /cohorts/1/rename -> Command::Cohort::Rename

Controller actions and routes can be inferred from the existence of query and command classes.

- Lead
  - Opportunities
  - Contacts
    - Emails
    - Phones
  - Activities
- User
- Inquiry (program applications, scholarship applications, contact forms, etc.)
- Program
  - Cohort
- Webhook

AggregateRoots:

- Inquiry
- Lead
- Program
- User
- Webhook?
