# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_discordia_session',
  :secret      => '57d8da3aad047d2b4f09502ec152ed408a4a0e32b8d33cc6ab7a17f1c5ebf3afcdaa6099a8c828603ca0445ff52d3a78742b5d4c05ec1c911adba3d21c48a90d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
