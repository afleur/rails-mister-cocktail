class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient
  validates :description, :cocktail, :ingredient, presence: true, allow_blank: false
  validates_uniqueness_of :cocktail, :scope => [:ingredient]
end
