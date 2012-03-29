require 'yaml'

module ApplicationHelper

  # I know, this code is unstable, because it doesn't check
  # outside date, but it's just for scientific interest. Seems,
  # in real apps errors notification is made another way.

  # convert error codes to error messages, using errors.yml,
  # delete duplicate errors for one field, if there are,
  # return error message and error codes for highlighting UI-fields
  def json_errors(arrs)
    msgs = YAML::load(File.open("#{Rails.root.to_s}/config/errors.yml"))
    err_codes = []
    result = {} 
    i = 0
    first_part = 'NULL' # just conversation over configuration :D 
    msg = 'You have errors:'
 
    arrs.each { |arr|
      if arr.scan(first_part)[0] == nil 
        parts = arr.split(' ')
        first_part = parts[0]
        msg += '<br>' + msgs[parts[-1]]
        err_codes[i] = parts[-1]
        i += 1
      end
    }

    result['msg'] = msg
    result['err_codes'] = err_codes
    
    return result.to_json                    
  end

end
