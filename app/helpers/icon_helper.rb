module IconHelper
  def icon(name, **options)
    path = "icons/#{name}.svg"
    options[:class] = class_names "bi", options[:class]
    options[:nocomment] = true
    # if no aria-label is provided, set aria-hidden to true for accessibility
    options[:aria_hidden] = options[:aria_label].blank?
    inline_svg_tag path, **options
  end
end
