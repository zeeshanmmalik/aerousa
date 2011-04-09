# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aerousa_session',
  :secret      => 'e97422b6951b589fd254c1d6701996bf4dd339f675c3c43ca64ba749cd4c505589d9240ee64c30b05d2e5c86019cb92b63a8f88cf796c74dd669a48841043593'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
