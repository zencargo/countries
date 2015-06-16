# encoding: utf-8

require 'spec_helper'
require 'countries/sources/osm'

describe ISO3166::Sources::OSM do
  describe 'when serching an area' do
    before do
      ad_data = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'fixtures', 'importer_ad.yaml')) || {}
      expect(subject).to receive(:query_area).and_return(ad_data).at_least(:once)
    end

    it 'will have osm keys' do
      expect(subject.query_for_country('AD')).to have_key :tags
    end

    it 'will pluralize sub keys that have data on parent key and sub keys' do
      expect(subject.query_for_country('AD')[:tags]).to have_key 'names'
    end

    it 'will split keys with colon into sub hashes' do
      expect(subject.query_for_country('AD')[:tags]['names'].size).to eql(91)
    end
  end
end
