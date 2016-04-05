#  Copyright 2016 Liqwyd Ltd.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

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
