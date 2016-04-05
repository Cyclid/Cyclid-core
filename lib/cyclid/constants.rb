module Cyclid
  # Module for the Cyclid API
  module API
    # Constant values
    module Constants
      # Identifiers for job statuses
      module JobStatus
        # Submitted
        NEW = 0
        # Runner has started, waiting for build host
        WAITING = 1
        # Runner has started
        STARTED = 2
        # Job has had a failed stage
        FAILING = 3

        # Job succeeded
        SUCCEEDED = 10
        # Job failed
        FAILED = 11
      end

      # Human readable job status strings
      JOB_STATUSES = {
        JobStatus::NEW => 'New',
        JobStatus::WAITING => 'Waiting',
        JobStatus::STARTED => 'Started',
        JobStatus::FAILING => 'Failing',
        JobStatus::SUCCEEDED => 'Succeeded',
        JobStatus::FAILED => 'Failed'
      }.freeze

      # Other one-off constants
      #
      # Default size for generating RSA key pairs
      RSA_KEY_LENGTH = 2048
    end
  end
end
