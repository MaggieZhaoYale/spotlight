class Spotlight::Search < ActiveRecord::Base
  self.table_name = 'spotlight_searches'
  belongs_to :exhibit
  serialize :query_params, Hash

  include Blacklight::SolrHelper

  def count
    query_solr(query_params, rows: 0, facet: false)['response']['numFound']
  end

  def images
    query_solr(query_params, rows: 1000, fl: blacklight_config.index.thumbnail_field, facet: false)['response']['docs'].map {|result| result[blacklight_config.index.thumbnail_field].first}
  end

  private

  def blacklight_config
    CatalogController.blacklight_config
  end

end