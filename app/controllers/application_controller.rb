class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  def authorize_user_with(policy, *params)
    unless policy.allowed?(*params)
      render :file => 'public/403.html', :status => :forbidden, :layout => false
    end
  end
end
