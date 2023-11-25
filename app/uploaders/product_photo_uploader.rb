class ProductPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # https://github.com/carrierwaveuploader/carrierwave#cve-2016-3714-imagetragick
  def content_type_allowlist
    [/image\//]
  end

  def extension_allowlist
    %w[jpg jpeg png webp]
  end

  def size_range
    1..7000000 # 7 MB
  end

  def width_range
    400..4000
  end

  def height_range
    400..4000
  end

  version :main do
    process resize_and_pad: [400, 400]
  end

  version :thumb do
    process resize_and_pad: [50, 50]
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # Note: I don't think this works
  def default_url(*args)
    ActionController::Base.helpers.asset_path(
      "fallbacks/products/" + [version_name, "default.png"].compact.join("_")
    )
  end
end
