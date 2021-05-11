# frozen_string_literal: true

Application.boot(:persistence) do |app|
  init do
    config = app['db.config']
    config.auto_registration(app.root.join('lib/persistence'))
    register('persistence', ROM.container(config))
  end
end
