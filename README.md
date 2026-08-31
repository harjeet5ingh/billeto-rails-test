# Billetto events & voting

A small Rails app that ingests events from the Billetto API, lists them, and
lets signed-in visitors upvote or downvote each one. Votes are recorded as
domain events through Rails Event Store rather than as a plain counter
column, and authentication is handled by Clerk.

## Requirements

- Ruby 3.3.0 (see `.ruby-version`)
- Bundler
- SQLite3
- Google Chrome (only needed to run the system spec locally)

## Setup

```bash
bundle install
bin/rails db:prepare
bin/rails billetto:ingest_events   # optional - pulls in events right away
bin/dev
```

Visit `http://localhost:3000`.

## Environment variables

Neither integration needs real credentials to run the app or its full test
suite - without them, both fall back to a fake adapter, matching how the
team already avoids stubbing real HTTP calls in tests:

- **Billetto**: set `BILLETTO_API_KEY` (and optionally `BILLETTO_API_BASE`,
  default `https://billetto.dk/api/v3/`) - or `rails credentials:edit` with
  `billetto: { api_key: ..., api_base: ... }` - to pull real events instead
  of the three canned sample events. Without a key, `Billetto::FakeClient`
  is used everywhere except in `Billetto::Client`'s own spec.
- **Clerk**: set `CLERK_SECRET_KEY` (must look like `sk_...`) and
  `CLERK_PUBLISHABLE_KEY` to enable real Clerk sign-in. Without a real
  looking secret key - and always in the test environment, regardless of
  what's set - the app skips Clerk's Rack middleware entirely and falls
  back to a local "fake session" sign-in form, so voting and its auth
  restriction are fully exercisable without a Clerk account. If you do add
  real keys, swap the placeholder script tag in
  `app/views/layouts/_auth_status.html.erb` for the exact snippet Clerk's
  dashboard gives you (it encodes your specific frontend API host).

## Running tests

```bash
bundle exec rspec
HEADLESS=0 bundle exec rspec spec/system   # watch the browser locally
```

## Design notes

- **Domain layout** follows this team's existing conventions: domain events
  ("facts") with a `SCHEMA` and `stream_names` live under `app/domain`,
  third-party integrations behind an ACL in `app/integrations`, and
  read models under `app/read_models`. See `app/domain/fact.rb`,
  `app/domain/command/executable.rb`, and `app/domain/handler.rb` for the
  small shared base classes this relies on.
- **Command dispatch** uses `arkency-command_bus` (already a transitive
  dependency of `rails_event_store`) directly rather than a hand-rolled bus.
  Each registered command runs inside an `ApplicationRecord` transaction.
- **Vote counts are a real read model**, not a `COUNT` query:
  `Voting::VoteCount` is maintained by `Voting::VoteCountProjector`, an
  async handler subscribed to `Voting::EventUpvoted` /
  `Voting::EventDownvoted`, and can be thrown away and rebuilt from the
  event log at any time with `rails read_models:rebuild_vote_counts`.
- **No local `User` model.** Votes carry an opaque `user_id` string - Clerk's
  `sub` claim in real mode, or the fake session's email in dev/test - since
  Clerk already owns identity and a shadow `User` table wouldn't add
  anything the brief asks for.
- **Both integrations (Billetto, Clerk)** sit behind a fake adapter that's
  used automatically in tests and in development until real credentials are
  configured, so the app and its whole spec suite run with zero external
  accounts.

## Assumptions

- Since there's no real Billetto API key available yet, the exact response
  shape was taken from the public API reference docs
  (`id`, `title`, `description`, `startdate`, `image_link`, `url`) rather
  than a live response - worth double-checking against a real key.
- Voting is a plain upvote/downvote per request rather than one-vote-per-user
  enforcement, since the brief doesn't specify that and the fake session
  flow has no real account to key that off reliably.
