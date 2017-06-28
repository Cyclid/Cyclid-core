#  Copyright 2017 Liqwyd Ltd.
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

require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'yaml'

module Cyclid
  # Module for the Cyclid job linter
  module Linter
    # A simple helper to track Warnings & Errors from the Verifier
    class StatusLogger
      attr_reader :messages, :warnings, :errors

      module MessageTypes
        WARNING = 0
        ERROR = 1
      end

      def initialize
        @messages = []
        @warnings = 0
        @errors = 0
      end

      def warning(message)
        @warnings += 1
        @messages << { type: MessageTypes::WARNING, text: message }
      end

      def error(message)
        @errors += 1
        @messages << { type: MessageTypes::ERROR, text: message }
      end
    end

    # Verify (lint) a Job for obvious errors and potential problems
    class Verifier
      module Bertrand
        UNKNOWN = 0
        NOT_EXIST = 1
        EXISTS = 2
      end

      attr_reader :status

      def initialize(*_args)
        @status = StatusLogger.new
      end

      def verify(definition)
        job = definition.deep_symbolize_keys

        # Does the data even look like a job?
        @status.error 'Job is not a hash?' \
          unless job.is_a? Hash

        @status.error 'Job is empty?' \
          if job.empty?

        # Lint all of the obvious, top-level stuff that makes up a basic job
        @status.error 'The Job does not have a name.' \
          unless job.key? :name

        @status.warning 'No version is defined for the Job. The default of 1.0.0 will be used.' \
          unless job.key? :version

        @status.warning 'No environment is defined. Defaults will apply.' \
          unless job.key? :environment

        @status.error 'No sequence is defined.' \
          unless job.key? :sequence

        # If any Stages are defined, check that each one looks valid
        verify_stages(job[:stages]) if job.key? :stages

        # Verify that the Sequence is valid, as much as possible
        verify_sequence(job[:sequence]) if job.key? :sequence
      rescue StandardError => ex
        @status.error "An unexpected error occured during the verification: #{ex}"
      end

      private

      def verify_stages(stages)
        @status.error 'Stages is not defined as an Array.' \
          unless stages.is_a? Array

        @status.warning 'Stages is defined but empty?' \
          if stages.empty?

        # Verify each Stage
        @ad_hoc_stages = []
        stages.each do |stage|
          unless stage.is_a? Hash
            @status.error 'A Stage is defined but is not an Object?'
            next
          end

          unless stage.key? :name
            @status.error 'A Stage is defined without a name.'
            next
          end

          # The Stage is at least a Hash with a name key...
          name = stage[:name]
          @ad_hoc_stages << name

          @status.error "The Stage '#{name}' is defined but empty." \
            if stage.empty?

          unless stage.key? :steps
            @status.error "The Stage '#{name}' does not define any Steps."
            next
          end

          @status.error "The Stage '#{name}' defines an empty set of Steps." \
            if stage[:steps].empty?

          @status.warning "No version is given for the Stage '#{name}'. " \
            'The default of 1.0.0 will be used.' \
            unless stage.key? :version
        end
      end

      def verify_sequence(sequence)
        @status.error 'The Sequence is not defined as an Array.' \
          unless sequence.is_a? Array

        @status.error 'The Sequence is defined but empty?' \
          if sequence.empty?

        # Verify each Stage and track all dependencies (stage, on_success, on_failure)
        dependencies = []
        sequence.each do |stage|
          unless stage.is_a? Hash
            @status.error 'A Stage in the Sequence is defined that is not an Object?'
            next
          end

          unless stage.key? :stage
            @status.error 'A Stage in the Sequence does not name a Stage to run.'
            next
          end

          name = stage[:stage]
          @status.warning 'A Stage in the Sequence does not specify a version for the ' \
            "Stage '#{name}'. The latest will always be used."

          dependencies << name.downcase
          dependencies << stage[:on_success].downcase if stage.key? :on_success
          dependencies << stage[:on_failure].downcase if stage.key? :on_failure
        end
        dependencies.uniq!

        # Check that every dependency exists
        dependencies.each do |dep|
          next if @ad_hoc_stages.include? dep

          # Okay, it's not defined in this job: does it exist on the server?
          case stage_exists? dep
          when Bertrand::UNKNOWN
            @status.warning "The Stage '#{dep}' in the Sequence is not defined in this job and " \
              'may not exist on the server.'
          when Bertrand::NOT_EXIST
            @status.error "The Stage '#{dep}' in the Sequence is not defined in this job and " \
              'does not exist on the server.'
          end
        end
      end

      # Find a Stage by it's name; this method will difer between Remote & Local
      # (server-side) verification, so is just a stub here.
      def stage_exists?(_name)
        Bertrand::UNKNOWN
      end
    end
  end
end
