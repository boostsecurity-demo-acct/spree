module Spree
  class CmsPage < Spree::Base
    include Spree::DisplayLink

    TYPES = ['Spree::Cms::Pages::StandardPage',
             'Spree::Cms::Pages::FeaturePage',
             'Spree::Cms::Pages::Homepage']

    extend FriendlyId
    friendly_id :slug, use: [:slugged, :finders, :history]

    belongs_to :store, touch: true
    has_many :cms_sections, dependent: :destroy

    has_many :menu_items, as: :linked_resource

    before_validation :handle_slug

    validates :title, presence: true
    validates :slug, uniqueness: { allow_nil: true, case_sensitive: true }

    scope :visible, -> { where(visible: true) }
    scope :by_store, ->(store) { where(store: store) }
    scope :by_locale, ->(locale) { where(locale: locale) }
    scope :linkable, -> { where.not(slug: nil, type: 'Spree::Cms::Pages::Homepage') }

    self.whitelisted_ransackable_attributes = %w[title type]

    def seo_title
      if meta_title.present?
        meta_title
      else
        title
      end
    end

    # Overide this if your page uses cms_sections
    def sections?
      false
    end

    def homepage?
      type == 'Spree::Cms::Pages::Homepage'
    end

    def visible?
      visible
    end

    def draft_mode?
      !visible
    end

    private

    def handle_slug
      self.slug = if homepage?
                    nil
                  elsif slug.blank?
                    title&.downcase&.to_url
                  else
                    slug&.downcase&.to_url
                  end
    end
  end
end