# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '2d4a0cc999cd7170f1bc909b2fa41ec0'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def soaarr
    ['zone','host','ttl','data','resp_person','refresh','retry','expire','minimum'];
  end
  
  def nsarr
    ['host','ttl','data']
  end
  
  def mxarr
    ['host','ttl','mx_priority','data']
  end
  
  def aarr
    ['host','ttl','data']
  end
  
  def cnamearr
    ['host','ttl','data']
  end
end
