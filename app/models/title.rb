class Title < ActiveRecord::Base
  named_scope :movies, :conditions => {:product_type => 1}
end
