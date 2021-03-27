# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(callsign: "gw7nvw", firstname: "Matt", lastname: "Briggs", email: "mattbriggs@yahoo.com", activated: true, is_active: true, is_admin: true,  is_modifier: true, password: "dummy", password_confirmation: "dummy")

