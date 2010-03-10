# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bellinghamatlas_session',
  :secret      => '56e483f9cdec0da5070931ee0e28dffe6830337a32b7d6c23a6658f92a834b6f9d934804879915c93be22c156ed7055f34bb47d36ee0765b13da6697c5415c99'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
