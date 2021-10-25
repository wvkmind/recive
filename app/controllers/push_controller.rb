require 'open-uri'
class PushController < ApplicationController
    IMAGES_PATH = File.join(Rails.root, "public")
    def create
        sn = params[:sn]
        password = params[:password]
        response = RestClient::Request.execute(method: {sn: sn, password: password}, url: 'https://hsk-embed.oray.com/devices/qrcode', headers: {}, timeout: 10)
        if response.code == 200
            json_body = JSON.parse(response.body)
            download = open(json_body[:qrcodeimg])
            IO.copy_stream(download, "#{IMAGES_PATH}/image.png")
        end
        render :json ,{code:0,data:nil}
    rescue => err
        render :json ,{code:0,data:nil}
    end
end
