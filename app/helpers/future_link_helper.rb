module FutureLinkHelper
  def future_link_to(name, **options, &block)
    options[:class] = class_names "future-link", options[:class]
    options[:title] = "This page doesn't yet exist but will in the future."
    link_to name, "javascript:;", **options, &block
  end
end
