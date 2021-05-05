# frozen_string_literal: true

Application.boot(:db) do
  init do
    connection = Sequel.connect(ENV['DATABASE_URL'], extensions: %i[pg_timestamptz])
    register('db.connection', connection)
    register('db.config', ROM::Configuration.new(:sql, connection))
  end
end
