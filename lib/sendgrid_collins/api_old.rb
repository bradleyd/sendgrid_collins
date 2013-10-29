require "collins_client"

# @todo this should really be decoupled from collins in case we ever switch infrastructure managers
module KvmBoss
  # handles all collins API calls
  class CollinsApi

    attr_reader :asset, :tools
    # @param [Hash] args
    # @param [String] host collins host
    # @param [String] username collins username
    # @param [String] password collins password
    # @param [KvmBoss::Guest Object] guest
    # @param [KvmBoss:Guest::Asset Object] asset 
    # @param [KvmBoss::Infrastructure Object] intake 
    # @param [KvmBoss::Infrastructure Object] provision 
    def initialize(args)
      @host      = args.fetch(:host) { "http://collins.sendgrid.net:8080" }
      @username  = args.fetch(:username)
      @password  = args.fetch(:password)
      @guest     = args.fetch(:guest)
      @asset     = @guest.asset
      @tools     = args.fetch(:tools) { KvmBoss::Tools }
      @intake    = args.fetch(:intake)
      @provision = args.fetch(:provision)
    end


    def connect
      @connection ||= Collins::Client.new(username: @username, password: @password, host: @host)
    end

    def find_asset(search_key, value)
      @connection.find(search_key => value)
    end

    # @param [String] key search key
    # @param [String] name hostname value
    # @reutrn [String, Array] single hostname or an array of hostnames. 
    # @note the search criteria is based off of  `profile-nnn-domain` so profile-* should work?
    def get_next_hostname(key="HOSTNAME", domain="sjc1.sendgrid.net", name)
      hostname = find_asset(key, "#{name}-*").map { |host| host.hostname }.sort
      if hostname.empty?
        hostname = [tools.build_default_hostname(@guest.profile)]
      end
      hostname
    end

    def address_pools(showall=true)
      @connection.ipaddress_pools()
    end

    def addresses_for_asset(asset_tag=asset.tag)
      @connection.addresses_for_asset(asset_tag)
    end
    
    # @param [String] asset tag
    # @param [Hash] opts
    def delete_asset(asset_tag=asset.tag, opts={})
      @connection.delete!(asset_tag, opts)
    end

    # @param [String] asset tag
    # @param [String] attribute
    def delete_attribute(asset_tag=asset.tag, attribute)
      @connection.delete_attribute!(asset_tag, attribute, group_id = nil)
    end

    # @param [String] asset tag
    # @param [String] pool
    def delete_ip_address(asset_tag=asset.tag, pool=nil)
      @connection.ipaddress_delete!(asset_tag, pool)  
    end

    def get_asset(asset_tag=asset.tag, opts={})
      @connection.get(asset_tag, opts)
    end

    # @param  [String] search_key
    # @param  [String] value
    # @return [Hash] collins asset
    def fuzzy_like_asset(search_key, value)
      @connection.find(search_key => /^value.*/)
    end

    # @return [Array] with provisioning profiles
    def get_profiles
      @connection.provisioning_profiles 
    end

    # @param  [Object] asset_tag asset object
    # @param  [Hash] opts 
    # @return [Collins::Asset] collins::asset tag is the most important variable
    # @example
    #  collins-shell asset create --tag=52-54-00-55-ad-a6
    #  <Collins::Asset:0x007f94a5178c20 @extras={}, @addresses=[], @created=#<DateTime: 2013-08-15T04:25:58+00:00 ((2456520j,15958s,0n),+0s,2299161j)>, @id=1699, @status="Incomplete", @tag="52-54-00-35-C4-BC", @type="SERVER_NODE", @state=#<Collins::AssetState:0x007f94a5183120 @description="", @id=0, @label="", @name="", @status=#<OpenStruct>>, @updated=nil, @deleted=nil, @ipmi=#<Collins::Ipmi:0x007f94a5182720 @address="", @asset_id=0, @gateway="", @id=0, @netmask="", @password="", @username="">, @power=[], @location=nil>
    def create_asset(asset_tag=asset.tag, opts ={})
      @connection.create!(asset_tag, opts)
    end

    # fetch ip from collins
    # @param  [Object] asset_tag asset object
    # @param  [String] pool vlan pool
    # @return [Array] Collins::Address  
    # @example 
    #  collins-shell ip_address allocate external_server --tag=52-54-00-55-ad-a6
    #  [#<Collins::Address:0x007f94a5140a00 @id=1762, @asset_id=1699, @address="10.42.83.117", @gateway="10.42.83.1", @netmask="255.255.255.0", @pool="INTERNAL_NO_DATA2">]
    def get_ipaddress(asset_tag=asset.tag, pool)
      @connection.ipaddress_allocate!(asset_tag, pool, count = 1)
    end

    # @param [Object] asset_tag asset object
    # @param [Hash] status_opts
    # Options Hash (hash):
    #   :status (String) —
    #   :reason (String) —
    # @example
    # collins-shell asset set_status --status=PROVISIONED --reason="kvm guest" --tag=52-54-00-f4-02-15
    def set_status(asset_tag=asset.tag, status_opts)
      @connection.set_status!(asset_tag, status_opts) 
    end

    # @param  [Object] asset_tag asset object
    # @param  [String] key attribute name
    # @param  [String] value attribute value
    # @return [Boolean] true or false
    # @example
    #  collins-shell asset set_attribute hostname sink-001.sjc1.sendgrid.net --tag=52-54-00-55-ad-a6
    #  collins-shell asset set_attribute kvm_host kvm-003.sjc1.sendgrid.net --tag=52-54-00-f0-ea-48
    def set_attribute(asset_tag=asset.tag, key, value)
      @connection.set_attribute!(asset_tag, key, value, group_id = nil)
    end

    # @param  [Object] asset_tag asset object
    # @param  [String] profile guest profile
    # @param  [String] contact who is provisioning
    #def provision_guest(asset_tag=asset.tag, profile=@guest.profile, contact="libvirt", opts={})
      #@connection.provision(asset_tag, profile, contact, opts)
    #end

    # runs #post on IntakeGuest
    def intake_guest
      @intake.post
    end

    # runs #post on ProvisonGuest
    def provision_guest
      @provision.post
    end
  end
end
