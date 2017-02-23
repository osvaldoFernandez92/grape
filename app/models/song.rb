class Song < ActiveRecord::Base
    has_many :tags

	validates :url, presence: true
end
