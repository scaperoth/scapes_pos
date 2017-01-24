class ApplicationController < ActionController::Base
    include TeamsHelper

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    before_action :authenticate_user!, except: [:login, :signup, :signout]
    before_filter :configure_permitted_parameters, if: :devise_controller?
    before_filter :configure_permitted_parameters, if: :devise_controller?

    protected

    def authenticate_team!
        # is user signed in an has a team?
        unless user_signed_in? && current_team.present?
            # If the user came from a page, we can send them back.  Otherwise, send
            # them to the root path.
            fallback_redirect = if request.env['HTTP_REFERER']
                                    :back
                                elsif defined?(root_path)
                                    root_path
                                else
                                    '/'
                                end

            redirect_to fallback_redirect, flash: { alert: 'You do not have permission to view this page.' }
        end
    end

    #->Prelang (user_login:devise)
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :remember_me])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :username, :email, :password, :remember_me])
        devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password])
    end

    private

    def after_sign_in_path_for(_resource)
        give_user_rand_team_name unless user_has_team?
        dashboard_path
    end

    def after_sign_up_path_for(_resource)
        give_user_rand_team_name unless user_has_team?
        dashboard_path
    end

    #-> Prelang (user_login:devise)
    def require_user_signed_in
        unless user_signed_in?

            # If the user came from a page, we can send them back.  Otherwise, send
            # them to the root path.
            fallback_redirect = if request.env['HTTP_REFERER']
                                    :back
                                elsif defined?(root_path)
                                    root_path
                                else
                                    '/'
                                end

            redirect_to fallback_redirect, flash: { alert: 'You must be signed in to view this page.' }
        end
    end
end
