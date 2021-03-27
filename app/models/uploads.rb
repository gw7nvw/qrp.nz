class Upload < ActiveRecord::Base
  has_attached_file :doc, 
    :url => "datafiles/:id",
    :path => ":rails_root/uploads/:id/:style/:basename.:extension"

  # validations, if any
end
