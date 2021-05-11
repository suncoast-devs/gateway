# frozen_string_literal: true

Application.boot(:db) do
  init do
    config = ROM::Configuration.new(:sql, ENV['DATABASE_URL'], extensions: %i[pg_timestamptz])
    register('db.config', config)
  end
end
