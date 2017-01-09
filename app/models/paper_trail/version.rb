module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern
    establish_connection :baye_trail_versions
  end
end
