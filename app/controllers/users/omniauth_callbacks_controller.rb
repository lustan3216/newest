class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    if user_signed_in?
      result = current_user.connect_to_facebook(request.env['omniauth.auth'])
      if result =='update'
        set_flash_message(:notice, :updated, kind: 'Facebook') if is_navigational_format?
      elsif result
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        set_flash_message(:notice, :failure, kind: 'Facebook', reason: 'already exist') if is_navigational_format?
      end
      redirect_to :back
    else
      @user = User.from_facebook_omniauth(request.env['omniauth.auth'],cookies['browser.timezone'])
      if @user == 'user_conflict'
        redirect_to new_user_session_url, alert: I18n.t('devise.failure.facebook_conflict_eamil')
      elsif @user.persisted?
        sign_in_and_redirect @user, event :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        session['devise.facebook_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end
  end

  def google_oauth2
    if user_signed_in?
      result = current_user.connect_to_google_omniauth(request.env['omniauth.auth'])
      if result =='update'
        set_flash_message(:force_time_zone, :updated, kind: 'Google+') if is_navigational_format?
      elsif result
        set_flash_message(:force_time_zone, :success, kind: 'Google+') if is_navigational_format?
      else
        set_flash_message(:force_time_zone, :failure, kind: 'Google+', reason: 'already exist') if is_navigational_format?
      end
      redirect_to profile_user_path(current_user)
    else
      @user = User.from_google_omniauth(request.env['omniauth.auth'],cookies['browser.timezone'])
      if @user.persisted?
        flash[:force_time_zone] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:force_time_zone, :success, kind: 'Google+') if is_navigational_format?
      else
        session['devise.google_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end
  end

  def failure
    redirect_to root_path
  end
end