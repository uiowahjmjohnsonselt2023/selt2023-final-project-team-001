class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_current_user

  def set_current_user
    Current.user = User.find_by(id: session[:user_id])
  end

  protected

  # Returns the translation for the current controller and action being processed.
  # Translations are located in the `config/locales` directory.
  #
  # A scope can be passed in to request a translation under a different namespace.
  # Default keys for the controller name are also searched if the key isn't found.
  #
  # For example, if the request is `GET profiles/1/edit` and the scope is
  # :require_login, the following translations will be checked (in order):
  #
  # * require_login.profiles.edit
  # * require_login.profiles.default
  # * require_login.default
  #
  # If none of those keys are found, nil will be returned.
  #
  # * action: the action name
  # * controller: the controller name
  #
  # This can be useful to customize the default translation for a specific action
  # or controller.
  #
  # @param scope [String, Symbol] The scope to use for the translation.
  # @param options [Hash] Additional options to pass to the translation method.
  # @return [String] The translated string.
  def i18n_t(scope: nil, **options)
    key = "#{controller_name}.#{action_name}"
    I18n.translate key,
      scope: scope,
      # Use symbols for defaults so that they're treated as keys;
      # strings are treated as values so won't be looked up
      default: [:"#{controller_name}.default", :default],
      # pass in the action and controller names as interpolations
      # in case defaults want to use them
      action: action_name,
      controller: controller_name,
      **options
  end

  # Redirects to the login page if the user is not logged in.
  # An :alert flash is set before redirecting, using the translation for
  # the requested controller and action under the :require_login scope.
  # See #i18n_t.
  def require_login
    unless Current.user
      flash[:alert] = i18n_t scope: :require_login
      redirect_to login_path
    end
  end

  # Redirects to the root path if the current user is not a seller.
  # An :alert flash is set before redirecting, using the translation for
  # the requested controller and action under the :require_seller scope.
  # See #i18n_t.
  def require_seller
    unless Current.user&.is_seller || Current.user&.is_admin
      flash[:alert] = i18n_t scope: :require_seller
      redirect_to root_path
    end
  end
end
