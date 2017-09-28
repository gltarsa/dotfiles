# Example file for commands needed to display all the models for a Rails app
# Also, cmd to list controllers is in a comment
Rails.application.eager_load!    # Load all modules (takes a few seconds)
ActiveRecord::Base.descendants

# ApplicationController.descendants # List all the controllers
