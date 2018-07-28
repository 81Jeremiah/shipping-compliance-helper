module Slugger


  module InstanceMethods
    def slug
      self.username.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
  end

  module ClassMethods
    def self.find_by_slug(slug)
      self.all.find{|user| user.slug == slug}
    end
  end

end