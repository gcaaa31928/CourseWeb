require 'base64'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'chunky_png'

module PortalImage

    def self.count_white_pixel_from_image(image)
        count = 0
        (0..image.dimension.width-1).each do |x|
            (0..image.dimension.height-1).each do |y|
                r = ChunkyPNG::Color.r(image[x, y])
                g = ChunkyPNG::Color.g(image[x, y])
                b = ChunkyPNG::Color.b(image[x, y])
                if r == 255 and g ==255 && b == 255
                    count += 1
                end
            end
        end
        count
    end

    def self.get_char_from_pixel_count(upper_count, lower_count)
        @@cmap.each do |key, array|
            if upper_count == array[0] and lower_count == array[1]
                return key
            end
        end
        p upper_count, lower_count
        raise 'can not find key'
    end


    @@cmap = {}
    @@cmap['a'] = [25, 55]
    @@cmap['b'] = [52, 51]
    @@cmap['c'] = [26, 32]
    @@cmap['d'] = [54, 50]
    @@cmap['e'] = [31, 48]
    @@cmap['f'] = [45, 21]
    @@cmap['g'] = [39, 74]
    @@cmap['h'] = [51, 42]
    @@cmap['i'] = [21, 21]
    @@cmap['j'] = [21, 38]
    @@cmap['k'] = [40, 47]
    @@cmap['l'] = [30, 21]
    @@cmap['m'] = [55, 63]
    @@cmap['n'] = [36, 42]
    @@cmap['o'] = [34, 46]
    @@cmap['p'] = [37, 63]
    @@cmap['q'] = [39, 62]
    @@cmap['r'] = [25, 21]
    @@cmap['s'] = [22, 33]
    @@cmap['t'] = [29, 25]
    @@cmap['u'] = [30, 49]
    @@cmap['v'] = [25, 33]
    @@cmap['w'] = [46, 62]
    @@cmap['x'] = [27, 35]
    @@cmap['y'] = [27, 43]
    @@cmap['z'] = [34, 42]
end

module Agent
    class MyParser
        def self.parse(thing, url = nil, encoding = nil, options = Nokogiri::XML::ParseOptions::DEFAULT_HTML, &block)
            # insert your conversion code here. For example:
            # thing = NKF.nkf("-wm0X", thing).sub(/Shift_JIS/,"utf-8") # you need to rewrite content charset if it exists.
            Nokogiri::HTML::Document.parse(thing, url, encoding, options, &block)
        end
    end

    def self.login_to_nportal(username, password, course_code)
        agent = Mechanize.new
        agent.html_parser = MyParser
        agent.user_agent_alias = 'Windows Mozilla'
        # agent.follow_meta_refresh = true
        page = agent.get('https://nportal.ntut.edu.tw/index.do')
        image = page.at '#authImage'
        now_time = Time.new + 3.seconds
        uri = agent.get('https://nportal.ntut.edu.tw/authImage.do?datetime='+now_time.strftime('%s%3N')).body_io
        file = File.open('portalImage.png', 'wb') do |f|
            f.write(uri.read)
        end
        image = ChunkyPNG::Image.from_file('portalImage.png')
        captcha = ''
        (0..3).each do |i|
            upper_image = image.crop(i*image.width/4, 0, image.width/4, image.height/2)
            lower_image = image.crop(i*image.width/4, image.height/2, image.width/4, image.height/2)
            upper_count = PortalImage::count_white_pixel_from_image(upper_image)
            lower_count = PortalImage::count_white_pixel_from_image(lower_image)
            char = PortalImage::get_char_from_pixel_count(upper_count, lower_count)
            captcha += char
        end
        form = page.form('login')
        form['muid']= username
        form['mpassword']= password
        form['authcode']= captcha
        page = agent.submit(form)
        page = agent.get('http://nportal.ntut.edu.tw/ssoIndex.do?apUrl=http://aps.ntut.edu.tw/course/tw/courseSID.jsp&apOu=aa_0010&sso=true&datetime1='+now_time.strftime('%s%3N'))
        form = page.form('ssoForm')
        page = agent.submit(form)
        page = agent.get('http://aps.ntut.edu.tw/course/tw/Select.jsp?format=-1&code='+course_code)
        doc = Nokogiri::HTML(page.body)
        table = doc.css('table')[2].css('tr').text
        p table
        # doc.xpath('//td').each do |node|
        #     puts node.text
        # end
    end
end
class AdminController < ApplicationController
    include PortalImage
    include Agent

    def login
        permitted = params.permit(:account, :password)
        permitted[:password] = Base64.decode64(permitted[:password])
        if permitted[:account] == 'wkchen' and permitted[:password] == 'oopcourse'
            admin = Admin.upsert
            render json: {
                       access_token: admin.access_token,
                       status: 200
                   }, status: 200
        else
            render json: {
                       error: 'Forbidden',
                       status: 400
                   }, status: 400
        end
    end

    def verify_access_token
        admin = Admin.find(0)
        if @access_token == admin.access_token
            true
        end
        false
    end


    def get_course_students
        @access_token = request.headers['AUTHORIZATION']

        Agent::login_to_nportal('104598037', 'qwerasdf40144', '209065')

        # if verify_access_token
        #     return render json: {
        #                error: 'Forbidden',
        #                status: 400,
        #            }, status: 400
        # end
        render json: {
                   status: 200
               }, status: 200

    end

end
