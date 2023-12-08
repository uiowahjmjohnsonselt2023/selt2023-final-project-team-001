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
  #
  # <code>
  # <li class="nav-item">
  #     <a class="nav-link" href="#{path}">#{text}</a>
  # </li>
  # </code>
  #
  # @param [Array] args If a block is given, the argument is the path. Otherwise, the
  #   arguments are the text and the path.
  # @param [Hash] options The options to pass to the link_to helper.
  # @option options [Hash] :li_options The options to pass to the navbar_item helper.
  # @option options [Boolean] :active Whether or not the link is active.
  # @option options [Boolean] :disabled Whether or not the link is disabled.
  # @yieldreturn [String] If given, the block is used as the link text.
  # @return [String] The HTML for the navbar link.
  def navbar_link(*args, **options, &block)
    path = block ? args[0] : args[1]

    li_options = options.delete(:li_options) || {}

    active = options.delete(:active) { current_page?(path) } && "active"
    disabled = options.delete(:disabled) && "disabled"
    options[:aria] = {current: "page"}.merge(options[:aria] || {}) if active
    options[:class] = class_names "nav-link", active, disabled, options[:class]

    link = if options.delete(:future_link)
      future_link_to(*args, **options, &block)
    else
      link_to(*args, **options, &block)
    end

    navbar_item(**li_options) { link }
  end

  # Creates a navbar dropdown.
  # <li class="nav-item dropdown">
  #     <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">#{text}</a>
  #     <ul class="dropdown-menu">...</ul>
  # </li>
  def navbar_dropdown(text, **options, &block)
    li_options = options.delete(:li_options) || {}
    li_options[:class] = class_names "dropdown", li_options[:class]
    ul_options = options.delete(:ul_options) || {}
    ul_options[:class] = class_names "dropdown-menu", ul_options[:class]

    options = options.delete(:options) || {}
    options[:role] = "button"
    options[:class] = class_names "nav-link", "dropdown-toggle", options[:class]
    options[:data] = {bs_toggle: "dropdown"}.merge(options[:data] || {})
    options[:aria] = {expanded: "false"}.merge(options[:aria] || {})

    navbar_item(**li_options) do
      out = []
      out << link_to(text, "#", **options)
      out << tag.ul(**ul_options, &block)
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

  def dropdown_divider(**options)
    li_options = options.delete(:li_options) || {}
    options[:class] = class_names "dropdown-divider", options[:class]
    tag.li(**li_options) { tag.hr(**options) }
  end

  def user_button(**options)
    if Current.user
      render "application/navbar/user_dropdown", user: Current.user, options: options
    else
      navbar_link("Login", login_path, **options)
    end
  end
end
