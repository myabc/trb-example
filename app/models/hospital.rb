class Hospital < ActiveRecord::Base
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  has_many :departments, dependent: :destroy

  scope :by_name, -> { order(name: :asc) }
  scope :published, -> { where published: true }

  def display_name
    "#{name} (#{acronym})"
  end

  def country
    @country ||= ISO3166::Country.new(country_code)
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  private

  def slug_candidates
    [
      :name,
      [:name, :city]
    ]
  end
end
