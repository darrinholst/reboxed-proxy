class Title < ActiveRecord::Base
  named_scope :movies, :conditions => {:product_type => 1}
  named_scope :since, lambda {|date| {:conditions => ["released >= ?", date]}}
  named_scope :most_recent, :order => "released desc"
  named_scope :oldest, :order => "released asc"
  named_scope :empty_metadata, :conditions => {:description => nil}
end
