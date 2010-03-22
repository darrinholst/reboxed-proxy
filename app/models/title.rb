class Title < ActiveRecord::Base
  named_scope :movies, :conditions => {:product_type => 1}
  named_scope :empty_metadata, :conditions => {:description => nil}
end
