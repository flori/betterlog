module Betterlog
  # Betterlog version
  VERSION         = '0.20.0'
  VERSION_ARRAY   = VERSION.split('.').map(&:to_i) # :nodoc:
  VERSION_MAJOR   = VERSION_ARRAY[0] # :nodoc:
  VERSION_MINOR   = VERSION_ARRAY[1] # :nodoc:
  VERSION_BUILD   = VERSION_ARRAY[2] # :nodoc:
end
