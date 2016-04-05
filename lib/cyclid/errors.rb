module Cyclid
  # Module for the Cyclid API
  module API
    # Error codes, for REST etc. statuses
    module Errors
      # Identifiers for HTTP JSON error bodies
      module HTTPErrors
        # Success
        NO_ERROR = 0
        # Something caught an exception
        INTERNAL_ERROR = 1
        # The JSON in the request body could not be parsed
        INVALID_JSON = 2
        # Invalid username or password, or not an admin
        AUTH_FAILURE = 3
        # A unique entry already exists
        DUPLICATE = 4

        # User does not exist
        INVALID_USER = 10
        # Organization does not exist
        INVALID_ORG = 11
        # Stage does not exist
        INVALID_STAGE = 12
        # No plugin found for the given action
        INVALID_ACTION = 13
        # Job definition is incorrect or does not exist
        INVALID_JOB = 14
        # Requested plugin does not exist
        INVALID_PLUGIN = 15
        # Could not get a configuration for the given plugin
        INVALID_PLUGIN_CONFIG = 16

        # API plugin request failed
        PLUGIN_ERROR = 20
      end

      # Human readable error strings
      ERROR_MESSAGES = {
        HTTPErrors::NO_ERROR => 'Success',
        HTTPErrors::INTERNAL_ERROR => 'Internal error',
        HTTPErrors::INVALID_JSON => 'The JSON in the request body could not be parsed',
        HTTPErrors::AUTH_FAILURE => 'Invalid username or password, or not an admin',
        HTTPErrors::DUPLICATE => 'Entry already exists',
        HTTPErrors::INVALID_USER => 'User does not exist',
        HTTPErrors::INVALID_ORG => 'Organization does not exist',
        HTTPErrors::INVALID_STAGE => 'Stage does not exist',
        HTTPErrors::INVALID_ACTION => 'No plugin found for the given action',
        HTTPErrors::INVALID_JOB => 'Job definition is incorrect or does not exist',
        HTTPErrors::INVALID_PLUGIN => 'Requested plugin does not exist',
        HTTPErrors::INVALID_PLUGIN_CONFIG => 'Could not get a configuration for the given plugin',
        HTTPErrors::PLUGIN_ERROR => 'API plugin request failed'
      }.freeze
    end

    # Internal exceptions
    module Exceptions
      # Base class for all internal Cyclid exceptions
      class CyclidError < StandardError
      end
    end
  end
end
