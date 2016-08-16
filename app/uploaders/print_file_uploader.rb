# encoding: utf-8

class PrintFileUploader < BaseUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.token}"
  end
end
