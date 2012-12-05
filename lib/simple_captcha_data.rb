# Copyright (c) 2008 [Sur http://expressica.com]

class SimpleCaptchaData < ActiveRecord::Base
  self.table_name = "simple_captcha_data"
  cattr_accessor :clear_counter, :counter_batch

  class << self
    def get_data(key)
      find_by_key(key) || new(:key => key)
    end
    
    def remove_data(key)
      clear_old_data
      data = find_by_key(key)
      data.destroy if data
    end
    
    def clear_old_data(time = 1.hour.ago)
      return unless Time === time
      self.clear_counter ||= -1
      self.counter_batch ||= 100
      self.clear_counter  += 1

      # trying not to clear/delete every single time
      if self.clear_counter == 0 || (self.clear_counter % self.counter_batch == 0)
        delete_all("updated_at < '#{time.to_s(:db)}'")
      end
    end
  end
  
end
