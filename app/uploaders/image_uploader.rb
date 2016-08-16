# encoding: utf-8

class ImageUploader < BaseUploader

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Process files as they are uploaded:
  # process :scale => [1200, 300]
  #
  def scale(width, height)
    resize_to_fill(width, height)
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [160, 160]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
