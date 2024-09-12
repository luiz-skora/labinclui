class LoginLog < ApplicationRecord
  def self.register_login(visit, user_id, message)
    l = new
    l.user_or_adm = user_id
    l.status = message
    l.ip = visit.ip
    l.visit_token = visit.visit_token
    l.location = [visit.country, visit.region, visit.city].join(', ')
    l.so = visit.os
    l.browser = visit.browser
    l.user_agent = visit.user_agent
    l.device = visit.device_type
    
    l.save!
    
    return l.id
  end
end
