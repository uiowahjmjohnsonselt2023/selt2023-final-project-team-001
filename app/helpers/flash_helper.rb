module FlashHelper
  TYPES = %i[primary secondary success danger warning info light dark].freeze
  FLASH_CLASS_MAP = {alert: :danger, notice: :success}.freeze
  ICON_NAME_MAP = {
    alert: "alert-triangle",
    notice: "info",
    success: "check-circle-2"
  }.freeze

  # Creates a flash message.
  # See views/application/_alert.html.erb for the HTML structure.
  def flash_message(type, message)
    type = type.to_sym
    type = FLASH_CLASS_MAP.fetch(type, :info) unless TYPES.include?(type)
    icon_name = ICON_NAME_MAP.fetch(type, "info")
    render "application/alert", type: type, message: message, icon_name: icon_name
  end

  def flash_messages
    safe_join flash.map { |type, message| flash_message(type, message) }
  end
end
