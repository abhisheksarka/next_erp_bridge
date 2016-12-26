# This code has been imported from https://github.com/NestAway/frappe-client(not authored by me)
# to remove dependency on the gem.
# TODO: Refactoring required

require 'httparty'

module NextErpBridge
  module Core
    class FrappeClient
      include HTTParty

      attr_accessor :url,
                    :session_cookie,
                    :username,
                    :password

      def initialize(opt_url=nil, opt_username=nil, opt_password=nil)
        self.url = opt_url || ERPNEXT_CONFIG["host_url"]
        self.username = opt_username || ERPNEXT_CONFIG["username"]
        self.password = opt_password || ERPNEXT_CONFIG["password"]
      end

      def login(username, password)
        action = "api/method/login"
        login_url = File.join(self.url, action)
        response = HTTParty.post(login_url, :body => {usr: username, pwd: password})
        self.session_cookie = "sid=#{parse_set_cookie(response.headers["set-cookie"])["sid"]}"
      end

      def get_all_doc_types
        # action =
      end

      def get_authenticated_user
        action = "api/method/frappe.auth.get_logged_user"
        login_url = File.join(self.url, action)
        response = HTTParty.get(login_url, :headers => {
          "Cookie" => self.session_cookie, "Content-Type" => "application/json",
          "Accept" => "application/json", "X-Frappe-CSRF-Token" => self.session_cookie
          })
        return response.parsed_response
      end

      def parse_set_cookie(all_cookies_string)
        cookies = Hash.new

        if !all_cookies_string.empty?
          all_cookies_string.split(',').each do |single_cookie_string|
            cookie_part_string  = single_cookie_string.strip.split(';')[0]
            cookie_part         = cookie_part_string.strip.split('=')
            key                 = cookie_part[0]
            value               = cookie_part[1]

            cookies[key] = value
          end
        end

        cookies
      end

      # This method is used to fetch more than one record
      # Example Response {"data"=>[{"name"=>"LEAD-00420"}, {"name"=>"LEAD-00419"}}

      # filters should be set in this format [{doctype}, {field}, {operator}, {operand}]
      # searching for Lead with email id ravi.lakhotia@nestaway.com : filters = [["Lead","email_id","=","ravi.lakhotia@nestaway.com"]]

      # fields : fields from the docType required in response. default is only name
      # fields can be set as follows : ["name","email_id"]

      def fetch(data, filters=[], fields=[], limit_start=0, limit_page_length=20)
        url_path = self.url + "/api/resource/" + data[:doctype] + "?filters=#{filters}&fields=#{fields}&limit_start=#{limit_start}&limit_page_length=#{limit_page_length}"
        encoded_url_path = URI.encode url_path

        response = HTTParty.get(encoded_url_path, :headers => {
          "Cookie" => self.session_cookie, "Accept" => "application/json",
          "X-Frappe-CSRF-Token" => self.session_cookie
        })
        return response.parsed_response
      end

      # To fetch all the details from ERP for single record
      # Example log in login_url = "https://nest.erpnext.com/api/resource/Lead/LEAD-00420"
      def fetch_single_record(data)
        url_path = self.url + "/api/resource/" + data[:doctype] + "/" + data[:id]
        encoded_url_path = URI.encode url_path

        response = HTTParty.get(encoded_url_path, :headers => {
          "Cookie" => self.session_cookie, "Accept" => "application/json",
          "X-Frappe-CSRF-Token" => self.session_cookie
          })
        return response.parsed_response
      end

      def insert(data)
        url_path = self.url + "/api/resource/" + data[:doctype]
        encoded_url_path = URI.encode url_path

        response = HTTParty.post(encoded_url_path, :headers => {
          "Cookie" => self.session_cookie, "Accept" => "application/json",
          "X-Frappe-CSRF-Token" => self.session_cookie,
          "application/x-www-form-urlencoded" => "multipart/form-data"
          }, :body => {:data => data.to_json})
        return response.parsed_response
      end

      def update(data)
        url_path = self.url + "/api/resource/" + data[:doctype] + "/" + data[:id]
        encoded_url_path = URI.encode url_path

        response = HTTParty.put(encoded_url_path, :headers => {
          "Cookie" => self.session_cookie, "Accept" => "application/json",
          "X-Frappe-CSRF-Token" => self.session_cookie,
          "application/x-www-form-urlencoded" => "multipart/form-data"
          }, :body => {:data => data.to_json})
        return response.parsed_response
      end

      def api_method(method_name, params)
        url_path = self.url + "/api/method/" + method_name
        encoded_url_path = URI.encode url_path

        response = HTTParty.post(encoded_url_path, :headers => {
          "Cookie" => self.session_cookie, "Accept" => "application/json",
          "X-Frappe-CSRF-Token" => self.session_cookie,
          "application/x-www-form-urlencoded" => "multipart/form-data"
          }, :body => params)
        return response.parsed_response
      end

      # This method can be used to call any raw api supported by frappe/erpnext

      def raw_api(url, request_type, params)
        url_path = self.url + url
        encoded_url_path = URI.encode url_path
        if request_type == "Get"
          response = HTTParty.get(encoded_url_path, :headers => {
          "Cookie" => self.session_cookie, "Accept" => "application/json",
          "X-Frappe-CSRF-Token" => self.session_cookie
          })
        else
          response = HTTParty.post(encoded_url_path, :headers => {
          "Cookie" => self.session_cookie, "Accept" => "application/json",
          "X-Frappe-CSRF-Token" => self.session_cookie,
          "Content-Type" => "application/x-www-form-urlencoded" }, :body => params)
        end
        return response.parsed_response
      end
    end
  end
end
