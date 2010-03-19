# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_redbox-cache_session',
  :secret      => '839787d0a9d8dc6bff959e9231694d14a3ece4eed29d007f8b494a1589d26f1a4c04ecb3875914fe2f586d9a6f391147d266f0b2faf5126b3a75434d1c1881a2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
