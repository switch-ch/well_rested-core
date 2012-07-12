require "well_rested-core/version"

# # require adapted libs
require 'well_rested/capi'
require 'well_rested/base'
require 'well_rested/core_formatter'

# Make sure 'bases' singularizes to 'base' instead of 'basis'.
# Otherwise, we get an error that no class Basis is found in Base.
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'base', 'bases'
end

module WellRested

  def logger
    return Rails.logger if Utils.class_exists? 'Rails'
    return @logger if @logger

    require 'logger'
    @logger = Logger.new(STDERR)
    @logger.datetime_format = "%H:%M:%S"
    @logger
  end

  module Core
    # autoload :API, 'well_rested/api'
  end
end
