module tools

import os
import x.json2
import net.http

pub struct Geo_Info {
	pub mut:
		ip						string
		version					string
		city					string
		region					string
		region_code				string
		country					string
		countryname				string
		countrycode				string
		countrycode_iso			string
		country_capital			string
		country_tld				string 
		continent_code			string
		in_eu					string
		postal					string
		latitude				string
		longitude				string
		timezone				string
		utc_offset				string
		country_calling_code	string
		currency				string
		currency_name			string
		languages				string
		country_area			string
		country_population		string
		asn 					string
		org						string
}

pub fn geoip(ip string) {
	mut geo_st := Geo_Info{}
	geo_json := http.get_text("https://ipapi.co/${ip}/json")

	convert_to_json := json2.raw_decode(geo_json)
	geo_info := convert_to_json.as_map()
	
	geo_st.ip 						= geo_info['ip'].str()
	geo_st.version 					= geo_info['version'].str()
	geo_st.city						= geo_info['city'].str()
	geo_st.region					= geo_info['region'].str()
	geo_st.region_code				= geo_info['region_code'].str()
	geo_st.country 					= geo_info['country'].str()
	geo_st.country_name				= geo_info['country_name'].str()
	geo_st.countrycode				= geo_info['country_code'].str()
	geo_st.countrycode_iso 			= geo_info['country_code_iso3'].str()
	geo_st.country_capital			= geo_info['country_capital'].str()
	geo_st.country_tld				= geo_info['country_tld'].str()
	geo_st.continent_code			= geo_info['continent_code'].str()
	geo_st.in_eu					= geo_info['in_eu'].str()
	geo_st.postal					= geo_info['postal'].str()
	geo_st.latitude					= geo_info['latitude'].str()
	geo_st.longitude				= geo_info['longitude'].str()
	geo_st.timezone					= geo_info['timezone'].str()
	geo_st.utc_offset				= geo_info['utc_offset'].str()
	geo_st.country_calling_code		= geo_info['country_calling_code'].str()
	geo_st.currency					= geo_info['currency'].str()
	geo_st.currency_name			= geo_info['currency_name'].str()
	geo_st.languages				= geo_info['languages'].str()
	geo_st.country_area				= geo_info['country_area'].str()
	geo_st.country_population		= geo_info['country_population'].str()
	geo_st.asn 						= geo_info['asn'].str()
	geo_st.org						= geo_info['org'].str()

	return geo_st
}	

pub fn dblookup() {

}

pub fn cfresolver() {
	
}
