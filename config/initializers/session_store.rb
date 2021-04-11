# Be sure to restart your server when you modify this file.

#Qrp::Application.config.session_store :cookie_store, key: '_qrp_session', domain: "qrp.nz"
Qrp::Application.config.session_store :active_record_store, key: '_qrp_session', :domain => :all

