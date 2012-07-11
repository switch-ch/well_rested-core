require "well_rested-core/version"

require "well_rested"

require 'well_rested/core_formatter'


# # require external dependencies
# require 'active_support/core_ext/hash/indifferent_access'
# require 'active_support/core_ext/hash/reverse_merge'

# # require internal general-use libs
# require 'key_transformer'
# require 'generic_utils'

# # require internal libs
# require 'well_rested/api'
# require 'well_rested/base'
# require 'well_rested/utils'
# require 'well_rested/json_formatter'
# require 'well_rested/core_formatter'
# require 'well_rested/camel_case_formatter'

# Make sure 'bases' singularizes to 'base' instead of 'basis'.
# Otherwise, we get an error that no class Basis is found in Base.
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'base', 'bases'
end

module WellRested
  module Core
    autoload :API, 'well_rested/api'
  end
end
