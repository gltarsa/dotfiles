local_variables.each { |v| puts "#{v} = (#{binding.local_variable_get(v)})" unless v.to_s[0]=="_"}
