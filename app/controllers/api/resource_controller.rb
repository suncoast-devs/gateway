module API
  class ResourceController < ActionController::API
    include Graphiti::Rails
    include Graphiti::Responders

    NotAuthorized = Class.new(StandardError)

    register_exception Graphiti::Errors::RecordNotFound, status: 404
    register_exception NotAuthorized, status: 403

    rescue_from Exception do |e|
      handle_exception(e)
    end

    before_action :authenticate!

    class_attribute :resource_class

    def index
      resources = resource_class.all(params)
      respond_with(resources)
    end

    def show
      resource = resource_class.find(params)
      respond_with(resource)
    end

    def create
      resource = resource_class.build(params)

      if resource.save
        render jsonapi: resource, status: 201
      else
        render jsonapi_errors: resource
      end
    end

    def update
      resource = resource_class.find(params)

      if resource.update_attributes
        render jsonapi: resource
      else
        render jsonapi_errors: resource
      end
    end

    def destroy
      resource = resource_class.find(params)

      if resource.destroy
        render jsonapi: { meta: {} }, status: 200
      else
        render jsonapi_errors: resource
      end
    end

    private

    def authenticate!
      raise NotAuthorized unless current_user
    end

    # TODO: API token auth
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    singleton_class.send :alias_method, :original_inherited, :inherited

    def self.inherited(subclass)
      original_inherited(subclass)
      subclass.resource_class = (subclass.controller_name.classify + "Resource").constantize
    end
  end
end
