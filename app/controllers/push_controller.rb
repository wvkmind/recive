require 'open-uri'
require 'rest-client'
class PushController < ApplicationController
    skip_before_action :verify_authenticity_token
    IMAGES_PATH = File.join(Rails.root, "public")
    def create
	@@current = Time.now.to_s
	data = JSON.parse(params["data"])['data']
        sn = data["device_sn"]
        password = data["device_sn_pwd"]
	Rails.logger.error sn 
	Rails.logger.error password
        response = RestClient::Request.execute(method: :post, url: 'https://hsk-embed.oray.com/devices/qrcode',payload:{sn: sn, password: password}.to_json, :headers => { content_type: :json, accept: :json }, timeout: 10)
        if response.code == 200
            json_body = JSON.parse(response.body)
	    Rails.logger.error json_body["qrcodeimg"]
	    uri = URI.parse(json_body["qrcodeimg"])
	    rfile = uri.open
	    wfile = File.open("#{IMAGES_PATH}/image.png",'wb') 
	    wfile.puts rfile.read
            wfile.close
	    wfile = File.open("#{IMAGES_PATH}/last_time",'wb')
	    wfile.puts Time.now.to_s
	    wfile.puts "\n"
	    wfile.puts "\0"
	    wfile.close
	    system 'rails restart'
        end
        render_json(json: {code: 0,data: nil})
    rescue => err
        Rails.logger.error ">>>message:#{err.message} #{JSON.pretty_generate(err.backtrace)}"
        render_json(json: {code: 0,data: nil})
    end
    def image
	render file: "#{IMAGES_PATH}/image.png"
    end
    def last_time
	wfile = File.open("#{IMAGES_PATH}/last_time",'rb')
	render_json(json: {time: wfile.readline})
    end
end
