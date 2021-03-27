class Upload < ActiveRecord::Base
has_attached_file :doc,
:path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
:url => "/system/:attachment/:id/:basename_:style.:extension"

validates_attachment :doc,
    :presence => true
validates_attachment_content_type :doc, :content_type =>["application/vnd.ms-excel",
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/vnd.oasis.opendocument.spreadsheet"],
             :message => ', Only EXCEL, ODS files are allowed. '



end
