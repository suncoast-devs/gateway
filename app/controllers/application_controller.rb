class ApplicationController < ActionController::Base
  private

  def execute(command)
    command_bus.(command)
  end

  def command_bus
    @command_bus ||= Rails.configuration.command_bus
  end

  def command_parameters
    request.request_parameters.deep_symbolize_keys
  end
end
