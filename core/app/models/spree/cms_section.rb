module Spree
  class CmsSection < Spree::Base
    include Spree::DisplayLink

    acts_as_list scope: :cms_page
    belongs_to :cms_page, touch: true

    belongs_to :linked_resource, polymorphic: true

    default_scope { order(position: :asc) }

    LINKED_RESOURCE_TYPE = []

    TYPES = ['Spree::Cms::Sections::FullScreenHeroImage',
             'Spree::Cms::Sections::HalfScreenPromotionBlock',
             'Spree::Cms::Sections::FeaturedArticle',
             'Spree::Cms::Sections::ProductCarousel',
             'Spree::Cms::Sections::ThreeTaxonCategoriesBlock',
             'Spree::Cms::Sections::StaticBrandingBar']

    # Overide this per section type
    def boundaries
      ['Container', 'Screen']
    end

    # Overide this per section type
    def widths
      ['Full', 'Half']
    end
  end
end