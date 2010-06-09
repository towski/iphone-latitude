# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_late_session',
  :secret      => 'b6a4b68227c3cb3d4118e7cc15c2b18772be2ad63552164c5baf951c8bb288d76f3dbb52dd765a19ab9ceacd4e878318c76f0766d52362b483b01639121cdda4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
