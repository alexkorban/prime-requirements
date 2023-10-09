class ActionMailer::Base
  include Delayed::Mailer
end

Delayed::Mailer.excluded_environments = [:test]  
