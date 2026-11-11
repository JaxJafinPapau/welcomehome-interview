# Welcomehome Interview

A small Rails app that models a senior living community's **rent roll** and
computes occupancy statistics *as of a chosen date*.

The heart of the app is `RentRollService`
([`app/services/rent_roll_service.rb`](app/services/rent_roll_service.rb)).
Given a date, it produces a rent roll (one row per unit) and reports how many
units are vacant, occupied, or leased.

## Data model

| Model       | Columns                              | Notes                                             |
| ----------- | ------------------------------------ | ------------------------------------------------- |
| `Unit`      | `number`, `floor_plan`               | A unit in the building.                           |
| `Resident`  | `name`                               | A person.                                         |
| `Occupancy` | `move_in`, `move_out`, `unit_id`, `resident_id` | A resident staying in a unit over a date range. |

`Occupancy` is the join between `Unit` and `Resident`. Both foreign keys are
nullable so an occupancy record can be retained even if the unit layout or
numbering changes, or a resident requests their data be removed.

## Requirements

- **Ruby** `4.0.6` (pinned in [`.ruby-version`](.ruby-version) — use rbenv/rvm)
- **PostgreSQL** 9.5 or newer
- **Bundler**

## Installation

```bash
# 1. Install dependencies
bundle install

# 2. Create the development database, load the schema, and seed it
#    (all in one step; see "Seeding data" below to seed on its own)
bin/rails db:setup
```

If you already have a database and just want to sync the schema:

```bash
bin/rails db:schema:load
```

## Seeding data

Seed data is read from
[`assets/units-and-residents.csv`](assets/units-and-residents.csv), which has the
columns `unit,floor_plan,resident,move_in,move_out` (dates in `M/D/YYYY`).
Rows with no resident represent an empty unit.

```bash
bin/rails db:seed
```

Seeding is **idempotent** — it uses `find_or_create_by`, so you can run it
repeatedly without creating duplicates. Edit the CSV and re-run to refresh the
data.

## Using the report service (Rails console)

Open the console and instantiate the service with the **"as of" date** you want
the rent roll evaluated at:

```bash
bin/rails console
```

```ruby
# Evaluate as of today
service = RentRollService.new(Date.today)

# Or a specific historical date
service = RentRollService.new(Date.parse("2021-06-01"))

# Print the rent roll (columns, then one row per unit)
service.report

# Print the summary statistics
service.statistics
```

### `#report`

Prints the column names followed by one row per unit. Each row carries a
`status` column:

| `status`    | Meaning                                                     |
| ----------- | ---------------------------------------------------------- |
| `nil`       | **Vacant** — no occupancy active as of the date.           |
| `current`   | **Occupied** — the tenant moved in on or before the date.  |
| `future`    | **Leased (future)** — the tenant is scheduled to move in after the date. |

Example output (printed with `p`, so strings appear quoted):

```text
["unit_number", "floor_plan", "resident_name", "move_in", "move_out", "status"]
[1, "Studio", "John Smith", Fri, 01 Jan 2021, nil, "current"]
[2, "Suite", "Sarah", Mon, 01 Mar 2021, nil, "current"]
[3, "Suite", nil, nil, nil, nil]
[5, "Suite", "Teddy", nil, nil, "future"]
```

### `#statistics`

Prints three counts derived from the same rent roll:

```text
Vacancies: 6
Occupancies: 2
Leased units: 4
```

- **Vacancies** — units with `status` `nil` (no active occupancy).
- **Occupancies** — units with `status` `current` (tenant in place as of the date).
- **Leased units** — units with `status` `current` *or* `future` (occupied or booked).

### How the "as of" date works

The underlying query joins `occupancies` with the condition
`move_out IS NULL OR move_out >= date`, so an occupancy is considered active on
the chosen date unless the tenant moved out *before* it. Occupancies that ended
before the date are excluded, and a `move_in` on or after the date is marked
`future`. This lets you reconstruct the rent roll for any point in time.

## Running the test suite

```bash
bundle exec rspec
```

Tests use RSpec + FactoryBot. The test database schema is kept in sync
automatically, so there is nothing to set up first.