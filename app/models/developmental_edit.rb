class DevelopmentalEdit < ApplicationRecord
    belongs_to  :user

    has_rich_text :description

    extend FriendlyId
    friendly_id :title, use: :slugged

    def should_generate_new_friendly_id?
        title_changed?
    end

    validates :title, presence: true
    validates :word_count, numericality: { greater_than_or_equal_to: 15000 }
    
    # Scopes
    default_scope { order(created_at: :desc) }
end
