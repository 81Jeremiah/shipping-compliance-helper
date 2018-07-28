module Slugger


  module ClassMethods
    def find_by_slug(slug)
      self.all.find{|value| value.slug == slug}
    end
  end

end