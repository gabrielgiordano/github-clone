class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery with: :exception, prepend: true

  def authorize_user_with(policy, *params)
    unless policy.allowed?(*params)
      render :file => 'public/403.html', :status => :forbidden, :layout => false
    end
  end

  private

  def layout_by_resource
    if devise_controller? && !devise_edit_user?
      "devise"
    else
      "application"
    end
  end

  def devise_edit_user?
    action_name == "edit" && controller_name == "registrations"
  end
end
