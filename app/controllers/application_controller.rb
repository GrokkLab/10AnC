class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :handle_subdomain

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def handle_subdomain
    subdomain =  request.subdomain

    is_empty_or_www = subdomain.empty? || subdomain == "www"
    search_path = is_empty_or_www ? %{"$user", public} : [subdomain.to_s, "public"].compact.join(",")

    connection = ActiveRecord::Base.connection
    ActiveRecord::Base.connection.schema_search_path = search_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
