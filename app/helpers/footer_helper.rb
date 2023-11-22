module FooterHelper
  # Creates a footer link.
  # See NavbarHelper#navbar_link for more information.
  def footer_link(*args, **options)
    options[:class] = class_names "px-2 text-body-secondary", options[:class]
    options[:active] ||= false # only allow active links if explicitly set to true
    navbar_link(*args, **options)
  end
end
