require 'overpass_api_ruby'
require 'active_support/inflector'

module ISO3166
  ##
  # handle importing data from OSM
  module Sources
    class OSM
      def query_for_country(name)
        clean_data query_area(name, 'country')
      end

      def query_for_country_by_name(name)
        clean_data query_area(name, 'country', lookup_key: 'name')
      end

      def query_for_countries
        query_all 'country'
      end

      def query_cities_for_country(name)
        clean_data query_area(name, 'city')
      end

      ##
      # This method is to crate nice hashes of related data.
      # OSM uses tags such as name:en: USA this will create
      # names: ['en' => 'USA']
      def clean_data(data)
        clean_data = {}
        return {} if data.nil?

        data[:tags].each do |k, v|
          tags = k.to_s.split(':')

          if tags.size  == 1
            clean_data[k] = v
          else
            if clean_data[tags[0]]
              clean_data["#{tags[0]}s"] ||= {}
              clean_data["#{tags[0]}s"][tags[1]] = v
            else
              clean_data["#{tags[0]}"] ||= {}
              clean_data["#{tags[0]}"][tags[1]] = v
            end
          end
        end

        data[:tags] = clean_data
        data

      rescue => error
        puts error
        puts error.backtrace
      end

      private

      def query_all(level)
        ba_query = "(node[place=\"#{level}\"];);out;"
        overpass = OverpassAPI.new
        data = overpass.raw_query(ba_query)
      end

      def query_area(name, level, lookup_key: 'ISO3166-1')
        ba_query = "area[\"#{lookup_key}\"=\"#{name}\"];(node[place=\"#{level}\"](area););out;"
        overpass = OverpassAPI.new
        data = overpass.raw_query(ba_query).first
      end
    end
  end
end
