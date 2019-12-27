# MailCatchex

A super simple SMTP server with a simpler UI to catch all emails sent to it. Useful for seeing sent emails while developing.

Inspired by `mailcatcher` for Ruby.

## Installation

The package can be installed
by adding `mail_catchex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mail_catchex, "~> 0.1.0", only: :dev}
  ]
end
```


## Usage

Add `MailCatchex.Supervisor` to your supervision tree. Like:

```
supervisor(MailCatchex.Supervisor, [smtp_port: 2525, http_port: 2526])
```

Both ports are optional, and the above values are the default ones.

Then point your send address to `localhost:2525` and point browser to `localhost:2526` to see received emails.

## License

Do what you want. Some credits would be nice, but totally optional.
