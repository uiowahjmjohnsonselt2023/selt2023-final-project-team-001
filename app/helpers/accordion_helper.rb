module AccordionHelper
  def accordion(**options, &block)
    options[:class] = class_names "accordion", options[:class]
    tag.div(**options, &block)
  end

  def accordion_item(header, id:, opened: false, &block)
    render "application/accordion/item", header: header, id: id, opened: opened, &block
  end
end
