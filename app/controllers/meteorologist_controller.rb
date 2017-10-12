require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    #Getting longitude and latitude from Google geocoding API
    
    clean_address = @street_address.gsub(" ","+")
    
    url_part1_geo = "https://maps.googleapis.com/maps/api/geocode/json?address=" 
    url_part2_geo = clean_address.to_s
    full_url_geo = url_part1_geo + url_part2_geo
    
    parsed_data_geo = JSON.parse(open(full_url_geo).read)
    latitude = parsed_data_geo["results"][0]["geometry"]["location"]["lat"]
    longitude = parsed_data_geo["results"][0]["geometry"]["location"]["lng"]
    
    #Getting weather from Dark Sky API
    
    url_part1_ds = "https://api.darksky.net/forecast/d0fe9147182202787fef209c17584b48/" 
    url_part2_ds = latitude.to_s
    url_part3_ds = longitude.to_s
    full_url_ds = url_part1_ds + url_part2_ds + "," + url_part3_ds
    
    parsed_data_ds = JSON.parse(open(full_url_ds).read)
    #latitude = parsed_data["currently"]["temperature"]
    #longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]

    @current_temperature = parsed_data_ds["currently"]["temperature"]

    @current_summary = parsed_data_ds["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data_ds["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data_ds["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data_ds["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
