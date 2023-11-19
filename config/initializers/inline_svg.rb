class LabelTransform < InlineSvg::CustomTransformation
  def transform(doc)
    with_svg(doc) do |svg|
      # value is an instance variable of InlineSvg::CustomTransformation
      svg["aria-label"] = value
      # Setting role is necessary for screen readers to read the label
      svg["role"] = "img"
    end
  end
end

InlineSvg.configure do |config|
  config.add_custom_transformation(attribute: :aria_label, transform: LabelTransform)
end
