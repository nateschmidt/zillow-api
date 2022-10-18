require 'rest-client'
require 'json'
require 'cgi'

class RestApi

    def initialize
      @headers = {
        'content-type': "application/json",
        'x-apikey': "-------",
        'cache-control': "no-cache"
      }
    end

    def string_between(string="",from="",to="")

      begin
        temp = string.split(from)
        temp2 = temp[1].split(to)
        hasil = temp2[0]
      rescue
        hasil = "-"
      ensure
        return hasil
      end

    end


    def get_zpid(address="")

      zillow_url = "https://www.zillowstatic.com/autocomplete/v3/suggestions?q="+address+"&clientId=static-search-page"


      response = RestClient::Request.execute(
          method: :get,
          url: zillow_url,
        ).body

        result = JSON.parse(response)


        return result['results'][0]['metaData']['zpid'].to_s
    end


    def call(zillow_url="")
        #response = RestClient.get(url, @headers)
        #html = response

        nate_api_key = "1c9e97f7abc9d5ef46ac32c6436f5de832e4705e"
        prio_api_key = "12dceb036f4c9db2074268ba3e1181fd9cb3e739"

        api_url = 'https://www.page2api.com/api/v1/scrape'
        payload = {
          api_key: nate_api_key,
          url: zillow_url,
          real_browser: true,
          premium_proxy: "us",
          parse: {
            title: 'title >>text',
            address: 'h1 >> text',
            status: '.Text-c11n-8-73-0__sc-aiai24-0.dpf__sc-1yftt2a-1.kHeRng.iOiapS >> text',
            html: 'html'


          }
        }

        response = RestClient::Request.execute(
          method: :post,
          payload: payload.to_json,
          url: api_url,
          headers: { "Content-type" => "application/json" },
        ).body

        result = JSON.parse(response)

        html = result['result']['html']

        address = string_between(html, '<meta property="og:zillow_fb:address" content="', '"')
        #result['result']['address']#

        status = string_between(html, '<span class="Text-c11n-8-73-0__sc-aiai24-0 dpf__sc-1yftt2a-1 kHeRng iOiapS">',"<")
        #result['result']['status']#
        #has = ""
        begin
          temp = html.split('bed-bath-beyond', -1)
          temp2 = temp[1].split('div class', -1)
          temp3 = temp2[0].split('Text-c11n-8-73-0__sc-aiai24-0 kHeRng',-1)
=begin
          temp = html.split('<span data-testid="bed-bath-beyond">', -1)
          temp2 = temp[1].split('</div>', -1)
          temp3 = temp2[0].split('<span class="Text-c11n-8-73-0__sc-aiai24-0 kHeRng">',-1)
=end
          bedroom=""
          bathroom=""
          sqft=""
          a = 1
          while a < temp3.length()

            item = temp3[a].split("span class")

            #has = has +"------"+item[0]
            if item[0].include? ">bd"
               #tm = item[0].split("<",-1)
               #bedroom = tm[0]
               bedroom = string_between(item[0],"strong>","<")
               #has = has +"<<<<<=======================THIS IS BEDROOM======"+bedroom+"============="
            elsif item[0].include? ">ba"
               #tm = item[0].split("<",-1)
               #bathroom = tm[0]
               bathroom = string_between(item[0],"strong>","<")
               #has = has +"<<<<<=======================THIS IS BATHROOM======"+bathroom+"============"
            elsif item[0].include? ">sqft"
               #tm = item[0].split("<",-1)
               #sqft = tm[0]
               sqft = string_between(item[0],"strong>","<")
               #has = has +"<<<<<=======================THIS IS SQFT===="+sqft+"=============="

            end

            a=a+1
          end
        rescue
          nothing=""
        ensure
          nothing=""
        end


        zestimate = string_between(html,">Zestimate<sup>","/span>")
        zestimate = string_between(zestimate,"<span>","<")


        rent_zestimate = string_between(html,">Rent Zestimate<sup>","/span>")
        rent_zestimate = string_between(rent_zestimate,"<span>","<")


        type = string_between(html,'\"Type\",\"factValue\":\"','\"')
        year_built = string_between(html,'\"Year Built\",\"factValue\":\"','\"')
        heating = string_between(html,'\"Heating\",\"factValue\":\"','\"')
        cooling = string_between(html,'\"Cooling\",\"factValue\":\"','\"')
        parking = string_between(html,'\"Parking\",\"factValue\":\"','\"')
        lot = string_between(html,'\"Lot\",\"factValue\":\"','\"')

        basement = string_between(html,'\"basement\":\"','\"')
        flooring = string_between(html,'\"flooring\":[',']')
        flooring = flooring.gsub!('\"', "") || flooring
        appliances = string_between(html,'\"appliances\":[',']')
        appliances = appliances.gsub!('\"', "") || appliances
        appliances = appliances.gsub!('\/', "/") || appliances
        fireplace = string_between(html,'\"hasFireplace\":',',')
        fireplace = fireplace.gsub!('true', "Yes") || fireplace
        fireplace = fireplace.gsub!('false', "No") || fireplace

        parking_feature = string_between(html,'\"parkingFeatures\":[',']')
        parking_feature = parking_feature.gsub!('\"', "") || parking_feature
        parcel_number = string_between(html,'\"parcelNumber\":\"','\"')


        exterior_feature = string_between(html,'\"exteriorFeatures\":[',']')
        exterior_feature = exterior_feature.gsub!('\"', "") || exterior_feature
        construction_material = string_between(html,'"constructionMaterials\":[',']')
        construction_material = construction_material.gsub!('\"', "") || construction_material
        foundation = string_between(html,'\"foundationDetails\":[',']')
        foundation = foundation.gsub!('\"', "") || foundation
        roof = string_between(html,'\"roofType\":\"','\"')
        roof = roof.gsub!('\/', "/") || roof


        region = string_between(html,'\"cityRegion\":\"','\"')

        object = Zillow.new(:address => address, :status => status, :bedrooms => bedroom, :bathrooms => bathroom, :sqft => sqft, :zestimate => zestimate, :rent_zestimate => rent_zestimate, :property_type => type, :year_built => year_built, :heating => heating, :cooling => cooling, :parking => parking, :lot => lot, :basement => basement, :flooring => flooring, :appliances => appliances, :fireplace => fireplace, :parking_feature => parking_feature, :parcel_number => parcel_number, :exterior_feature => exterior_feature, :construction_material => construction_material, :foundation => foundation, :roof => roof, :region => region )
        object.save

        res = { address: address, status: status, bedroom: bedroom, bathroom: bathroom, sqft:sqft, zestimate: zestimate, rent_zestimate: rent_zestimate, property_type: type, year_built: year_built, heating: heating, cooling: cooling, parking: parking, lot: lot, basement: basement, flooring: flooring, appliances: appliances, fireplace: fireplace, parking_feature: parking_feature, parcel_number: parcel_number, exterior_feature: exterior_feature, construction_material: construction_material, foundation: foundation, roof: roof, region: region}

        return res

    end
end
