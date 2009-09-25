# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def soaarr
    ['zone','host','ttl','data','resp_person','refresh','retry','expire','minimum']
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
