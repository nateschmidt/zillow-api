require 'cgi'

class ApplicationController < ActionController::API


	def zillow

		rdb = RestApi.new

		#address = "213 Edgeview Ave #10A, Birmingham, AL 35209"
		#address = "117 W Glenwood Dr Birmingham, AL 35209"
		#address = "224 Montgomery Ln, Birmingham, AL 35209"
		address = params[:address]

		address = address&.gsub! ' ', '000SPACE000'
		address = address&.gsub(/[^0-9a-z ]/i, '')
		address = address&.gsub! '000SPACE000', '-'

		zpid = rdb.get_zpid(address)

		zillow_url = "https://www.zillow.com/homes/" + address+"/"+zpid+"_zpid/"
		#zillow_url = 'https://www.zillow.com/homes/117-W-Glenwood-Dr-Birmingham,-AL-35209_rb/1004003_zpid/'


		json = rdb.call(zillow_url)

		render json: json
	end
end