class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

 # Deviseにだけ別のレイアウト使用
  layout :layout_by_resource

  # deviseコントローラーにストロングパラメータを追加する
  before_action :configure_permitted_parameters, if: :devise_controller?

protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :occupation, :password, :password_confirmation, :remember_me, :image, :introduction, :user_tag]
 # サインアップ時にストロングパラメータを追加
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
 # サインイン時にストロングパラメータを追加
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
# アカウント編集の時にストロングパラメータを追加
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

 # Devise用のレイアウト指定
  def layout_by_resource
    if devise_controller?
      "sub-layout"
    else
      "application"
    end
  end
end