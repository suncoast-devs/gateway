# frozen_string_literal: true

Application.boot(:db) do
  init {}

  start do
    config = ROM::Configuration.new(:sql, ENV['DATABASE_URL'], extensions: %i[pg_timestamptz])
    register('db.config', config)
  end
end
