module NavbarHelper
  # <li class="nav-item">...</li>
  def navbar_item(**options, &block)
    options[:class] = class_names "nav-item", options[:class]
    # <li class="nav-item">...</li>
    tag.li(**options, &block)
  end

  # Creates a navbar link.
  # If the current page is the linked page, the link is given the active class. This
  # can be overridden by passing the :active option.
  # <code>
  # <li class="nav-item">
  #     <a class="nav-link" href="#{path}">#{text}</a>
  # </li>
  # </code>
  # @param [String] text The text to display in the link.
  # @param [String] path The path to link to.
  # @param [Hash] options The options to pass to the link_to helper.
  # @option options [Hash] :li_options The options to pass to the navbar_item helper.
  # @option options [Boolean] :active Whether or not the link is active.
  # @option options [Boolean] :disabled Whether or not the link is disabled.
  def navbar_link(text, path, **options)
    li_options = options.delete(:li_options) || {}

    active = options.delete(:active) { current_page?(path) } && "active"
    disabled = options.delete(:disabled) && "disabled"
    options[:aria] = {current: "page"}.merge(options[:aria] || {}) if active
    options[:class] = class_names "nav-link", active, disabled, options[:class]

    navbar_item(**li_options) { link_to(text, path, **options) }
  end

  # Creates a navbar dropdown.
  # <li class="nav-item dropdown">
  #     <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">#{text}</a>
  #     <ul class="dropdown-menu">...</ul>
  # </li>
  def navbar_dropdown(text, **options, &block)
    li_options = options.delete(:li_options) || {}
    li_options[:class] = class_names "dropdown", li_options[:class]

    a_options = options.delete(:a_options) || {}
    a_options[:role] = "button"
    a_options[:class] = class_names "nav-link", "dropdown-toggle", a_options[:class]
    a_options[:data] = {bs_toggle: "dropdown"}.merge(a_options[:data] || {})
    a_options[:aria] = {expanded: "false"}.merge(a_options[:aria] || {})

    navbar_item(**li_options) do
      out = []
      out << link_to(text, "#", **a_options)
      out << tag.ul(class: "dropdown-menu", **options, &block)
      safe_join out
    end
  end

  # Creates a navbar dropdown link.
  # <li><a class="dropdown-item" href="#{path}">#{text}</a></li>
  def dropdown_link(text, path, **options)
    li_options = options.delete(:li_options) || {}
    options[:class] = class_names "dropdown-item", options[:class]
    tag.li(**li_options) { link_to(text, path, **options) }
  end
end
