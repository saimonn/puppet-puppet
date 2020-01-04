# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
# provides a "random" value to cron based on the last bit of the machine IP address.
# used to avoid starting a certain cron job at the same time on all servers.
# takes the runinterval in seconds as parameter and return an array of [hour, minute]
#
# example usage
# ip_to_cron(3600) - returns [ '*', one value between 0..59 ]
# ip_to_cron(1800) - returns [ '*', an array of two values between 0..59 ]
# ip_to_cron(7200) - returns [ an array of twelve values between 0..23, one value between 0..59 ]
# ---- original file header ----
#
# @summary
#   Summarise what the function does here
#
Puppet::Functions.create_function(:'ip_to_cron') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    
    runinterval = (args[0] || 30).to_i
    ip          = lookupvar('ipaddress').to_s.split('.')[3].to_i
    if runinterval <= 3600
      occurances = 3600 / runinterval
      scope = 60
      base = ip % scope
      hour = '*'
      minute = (1..occurances).map { |i| (base - (scope / occurances * i)) % scope }.sort
    else
      occurances = 86400 / runinterval
      scope = 24
      base = ip % scope
      hour = (1..occurances).map { |i| (base - (scope / occurances * i)) % scope }.sort
      minute = ip % 60
    end
    [ hour, minute ]
  
  end
end
